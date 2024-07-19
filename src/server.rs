use std::{
    sync::{
        atomic::{AtomicUsize, Ordering},
        Arc,
    },
    time::Duration,
};

use bevy::{
    prelude::*,
    render::{
        render_resource::{Extent3d, TextureDimension, TextureFormat},
        texture::ImageSampler,
    },
    tasks::{AsyncComputeTaskPool, Task},
    time::Time,
};
use futures_lite::future;
use veloren_common::consts::MIN_RECOMMENDED_TOKIO_THREADS;
use veloren_server::{persistence::DatabaseSettings, Input, Server};

pub fn init_server() -> Server {
    let server_data_dir = {
        let mut path = veloren_common_base::userdata_dir_workspace!();
        println!("Using userdata folder at {}", path.display());
        path.push(veloren_server::DEFAULT_DATA_DIR_NAME);
        path
    };
    // We don't need that many threads in the async pool, at least 2 but generally
    // 25% of all available will do
    // TODO: evaluate std::thread::available_concurrency as a num_cpus replacement
    let runtime = Arc::new(
        tokio::runtime::Builder::new_multi_thread()
            .enable_all()
            .worker_threads((num_cpus::get() / 4).max(MIN_RECOMMENDED_TOKIO_THREADS))
            .thread_name_fn(|| {
                static ATOMIC_ID: AtomicUsize = AtomicUsize::new(0);
                let id = ATOMIC_ID.fetch_add(1, Ordering::SeqCst);
                format!("tokio-server-{}", id)
            })
            .build()
            .unwrap(),
    );

    #[cfg(feature = "hot-agent")]
    {
        agent::init();
    }
    #[cfg(feature = "hot-site")]
    {
        world::init();
    }

    // Load server settings
    let mut server_settings = veloren_server::Settings::load(&server_data_dir);
    let editable_settings = veloren_server::EditableSettings::load(&server_data_dir);

    // Apply no_auth modifier to the settings
    server_settings.auth_server_address = None;

    // Relative to data_dir
    const PERSISTENCE_DB_DIR: &str = "saves";

    let database_settings = DatabaseSettings {
        db_dir: server_data_dir.join(PERSISTENCE_DB_DIR),
        sql_log_mode: veloren_server::persistence::SqlLogMode::Disabled,
    };

    // Create server
    Server::new(
        server_settings,
        editable_settings,
        database_settings,
        &server_data_dir,
        &|stage| {
            info!("{stage:?}");
        },
        runtime,
    )
    .expect("Failed to create server instance!")
}

pub enum VelorenServer {
    Starting(Task<Server>),
    Running { server: Server, tps: u32 },
}

impl FromWorld for VelorenServer {
    fn from_world(_world: &mut bevy::prelude::World) -> Self {
        let thread_pool = AsyncComputeTaskPool::get();

        let task = thread_pool.spawn(async move { init_server() });

        VelorenServer::Starting(task)
    }
}

pub fn veloren_plugin(app: &mut App) {
    app.init_non_send_resource::<VelorenServer>()
        .add_system(handle_server_task);
}

fn create_world_image(server: &Server) -> Image {
    let map_msg = server
        .state()
        .ecs()
        .fetch::<veloren_common_net::msg::WorldMapMsg>();
    let size = map_msg.rgba.size();

    let data = map_msg
        .rgba
        .raw()
        .iter()
        .flat_map(|i| {
            let mut bytes = i.to_le_bytes();
            bytes[3] = 255;
            bytes
        })
        .collect();
    let mut image = Image::new(
        Extent3d {
            width: size.x as _,
            height: size.y as _,
            depth_or_array_layers: 1,
        },
        TextureDimension::D2,
        data,
        TextureFormat::Rgba8Unorm,
    );

    image.sampler_descriptor = ImageSampler::nearest();

    image
}

fn handle_server_task(
    mut commands: Commands,
    mut images: ResMut<Assets<Image>>,
    mut server: NonSendMut<VelorenServer>,
    time: Res<Time>,
    mut last_ran: Local<Option<f64>>,
) {
    match &mut *server {
        VelorenServer::Starting(task) => {
            if let Some(server_res) = future::block_on(future::poll_once(task)) {
                let image = images.add(create_world_image(&server_res));
                commands.spawn(SpriteBundle {
                    transform: Transform::from_scale(Vec3::new(32.0, -32.0, 1.0))
                        .with_translation(Vec3::new(0.0, 0.0, 0.0)),
                    texture: image,
                    ..default()
                });
                println!("Spawn map");
                *server = VelorenServer::Running {
                    server: server_res,
                    tps: 30,
                };
            }
        }
        VelorenServer::Running { server, tps } => {
            let dt = 1.0 / *tps as f64;
            let real_dt = last_ran
                .map(|t| time.elapsed_seconds_f64() - t)
                .unwrap_or(dt);
            if real_dt >= dt {
                *last_ran = Some(time.elapsed_seconds_f64());
                server
                    .tick(Input::default(), Duration::from_secs_f64(real_dt))
                    .expect("Failed to tick server");
            }
        }
    }
}

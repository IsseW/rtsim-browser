#![feature(let_chains)]
use specs::{Join, WorldExt};
use std::cmp::Ordering;

use bevy::{
    prelude::*,
    render::{
        primitives::{Aabb, Frustum, Sphere},
        view::{VisibilitySystems, VisibleEntities},
        Extract, RenderApp,
    },
    sprite::{ExtractedSprite, ExtractedSprites, SpriteSystem},
};
use bevy_egui::EguiPlugin;
use bevy_pancam::{PanCam, PanCamPlugin};
use seldom_fn_plugin::FnPluginExt;
use veloren_common::{
    comp::{Body, Pos, Presence},
    rtsim::{NpcId, Role},
};
use veloren_server::rtsim::RtSim;
use veloren_world::site::SiteKind;
mod editor;
mod server;

fn main() {
    let mut app = App::new();
    app.add_plugins(DefaultPlugins.set(WindowPlugin {
        primary_window: Some(Window {
            title: "RtSim Browser".to_string(),
            ..default()
        }),
        ..default()
    }))
    .add_plugin(EguiPlugin)
    .add_plugin(PanCamPlugin)
    .init_resource::<VisibleNpcs>()
    .init_resource::<SelectedNpc>()
    .add_startup_system(setup)
    .add_system(select_npcs)
    .add_system(editor::ui)
    .add_system(
        unit_always_visible
            .in_base_set(CoreSet::PostUpdate)
            .after(VisibilitySystems::CheckVisibility),
    )
    .init_resource::<RtsimSprites>()
    .add_system(extract_sprites.in_base_set(CoreSet::PostUpdate))
    .fn_plugin(server::veloren_plugin);

    if let Ok(render_app) = app.get_sub_app_mut(RenderApp) {
        render_app.add_system(
            extract_sprites_render
                .in_schedule(ExtractSchedule)
                .after(SpriteSystem::ExtractSprites),
        );
    }

    app.run();
}

fn setup(mut commands: Commands, asset_server: Res<AssetServer>) {
    commands.insert_resource(ImageAssets {
        humanoid: asset_server.load("rtsim/humanoid.png"),
        monster: asset_server.load("rtsim/monster.png"),
        bird: asset_server.load("rtsim/bird.png"),
        ship: asset_server.load("rtsim/ship.png"),
        white: asset_server.load("rtsim/white.png"),
    });
    commands.spawn_empty().insert(UnitEntity);
    commands.spawn(Camera2dBundle::default()).insert(PanCam {
        grab_buttons: vec![MouseButton::Middle],
        ..default()
    });
}

#[derive(Component)]
struct UnitEntity;

fn unit_always_visible(
    unit: Query<Entity, With<UnitEntity>>,
    mut visibility: Query<&mut VisibleEntities>,
) {
    let entity = unit.single();
    for mut visible_entities in visibility.iter_mut() {
        visible_entities.entities.push(entity);
    }
}

#[derive(Resource)]
struct ImageAssets {
    humanoid: Handle<Image>,
    monster: Handle<Image>,
    bird: Handle<Image>,
    ship: Handle<Image>,
    white: Handle<Image>,
}

#[derive(Resource, Default)]
pub struct VisibleNpcs(Vec<(NpcId, Vec3)>);

#[derive(Resource, Default)]
pub struct SelectedNpc(Option<NpcId>);

fn select_npcs(
    mut visible_npcs: ResMut<VisibleNpcs>,
    mut selected_npc: ResMut<SelectedNpc>,
    server: NonSend<server::VelorenServer>,
    cam: Query<(&GlobalTransform, &Frustum, &Camera, &OrthographicProjection), With<PanCam>>,
    input: Res<Input<MouseButton>>,
    window: Query<&Window>,
) {
    let window = window.single();
    let cam = cam.single();
    visible_npcs.0.clear();
    if let server::VelorenServer::Running { server, .. } = &*server {
        let rtsim = server.state().ecs().fetch::<RtSim>();
        let data = &*rtsim.state().data();
        for (id, npc) in data.npcs.npcs.iter() {
            let size = server.world().sim().get_size().as_();
            let pos = npc.wpos.xy() - size * 16.0;
            let pos = Vec3::new(pos.x, pos.y, 1.0);

            if cam.1.intersects_sphere(
                &Sphere {
                    center: pos.into(),
                    radius: 5.0,
                },
                true,
            ) {
                visible_npcs.0.push((id, pos));
            }
        }
        if let Some(cursor_pos) = window
            .cursor_position()
            .and_then(|cursor| cam.2.viewport_to_world_2d(cam.0, cursor))
        {
            if input.just_pressed(MouseButton::Right) {
                if let Some((id, _, _)) = visible_npcs
                    .0
                    .iter()
                    .map(|&(id, pos)| (id, pos, pos.truncate().distance_squared(cursor_pos)))
                    .filter(|(_, _, d)| *d < 5.0 * (2.0 * cam.3.scale.powi(2)).max(1.0))
                    .min_by(|(_, _, a), (_, _, b)| a.partial_cmp(b).unwrap_or(Ordering::Equal))
                {
                    selected_npc.0 = Some(id);
                } else {
                    selected_npc.0 = None;
                }
            }
        }
    }
}

#[derive(Resource, Default)]
struct RtsimSprites(Vec<ExtractedSprite>);

fn extract_sprites_render(
    mut extraced_sprites: ResMut<ExtractedSprites>,
    rtsim_sprites: Extract<Res<RtsimSprites>>,
) {
    extraced_sprites
        .sprites
        .extend(rtsim_sprites.0.iter().cloned());
}

fn extract_sprites(
    mut rtsim_sprites: ResMut<RtsimSprites>,
    images: Res<ImageAssets>,
    server: NonSend<server::VelorenServer>,
    entity: Query<Entity, With<UnitEntity>>,
    visible_npcs: Res<VisibleNpcs>,
    selected_npc: Res<SelectedNpc>,
    cam: Query<(&OrthographicProjection, &Frustum), With<PanCam>>,
) {
    rtsim_sprites.0.clear();
    if let server::VelorenServer::Running { server, .. } = &*server {
        let (proj, frustum) = cam.single();
        let entity = entity.single();
        let ecs = server.state().ecs();
        let rtsim = ecs.fetch::<RtSim>();
        let data = &*rtsim.state().data();
        let transform_point = |p, z| {
            let size = server.world().sim().get_size().as_();
            let pos: vek::Vec2<f32> = p - size * 16.0;
            Vec3::new(pos.x, pos.y, z)
        };
        let mut extract_npc = |pos: Vec3, color: Color, image: &Handle<Image>| {
            rtsim_sprites.0.push(ExtractedSprite {
                entity,
                transform: Transform::from_translation(pos)
                    .with_scale(Vec3::splat((0.5 * proj.scale).max(0.1)))
                    .into(),
                color,
                rect: None,
                custom_size: None,
                image_handle_id: image.id(),
                flip_x: false,
                flip_y: false,
                anchor: Vec2::ZERO,
            })
        };
        for (pos, _) in (&ecs.read_storage::<Pos>(), &ecs.read_storage::<Presence>()).join() {
            let pos = transform_point(pos.0.xy(), 1.0);
            extract_npc(pos, Color::PURPLE, &images.humanoid);
        }
        for (id, pos, npc) in visible_npcs
            .0
            .iter()
            .filter_map(|(id, pos)| Some((*id, *pos, data.npcs.get(*id)?)))
        {
            let color = if Some(id) == selected_npc.0 {
                Color::PINK
            } else {
                match npc.role {
                    Role::Civilised(_) => Color::YELLOW,
                    Role::Wild => Color::ORANGE,
                    Role::Monster => Color::RED,
                    Role::Vehicle => Color::ALICE_BLUE,
                }
            };
            let image = if proj.scale > 2.0 {
                &images.white
            } else {
                match npc.body {
                    Body::Humanoid(_) => &images.humanoid,
                    Body::BirdLarge(_) => &images.bird,
                    Body::Ship(_) => &images.ship,
                    _ => &images.monster,
                }
            };
            extract_npc(pos, color, image);
        }
        let get_min_max = |aabr: vek::Aabr<i32>| -> (Vec3, Vec3) {
            let min = transform_point(aabr.min.as_::<f32>(), 0.5);
            let max = transform_point(aabr.max.as_::<f32>(), 0.5);
            (min, max)
        };
        let contains_aabr = |aabr: vek::Aabr<i32>| {
            let (min, max) = get_min_max(aabr);
            frustum.intersects_obb(&Aabb::from_min_max(min, max), &Mat4::IDENTITY, false, false)
        };
        let mut extract_aabr =
            |site: &veloren_world::site2::Site, bounds: vek::Aabr<i32>, color: Color| {
                let bounds = vek::Aabr {
                    min: site.tile_wpos(bounds.min),
                    max: site.tile_wpos(bounds.max),
                };
                if !contains_aabr(bounds) {
                    return;
                }
                let (min, max) = get_min_max(bounds);
                let size = max - min;
                let half_size = size / 2.0;
                let center = min + half_size;
                rtsim_sprites.0.push(ExtractedSprite {
                    entity,
                    transform: Transform::from_translation(center)
                        .with_scale(Vec3::new(half_size.x, half_size.y, 1.0) / 8.0)
                        .into(),
                    color,
                    rect: None,
                    custom_size: None,
                    image_handle_id: images.white.id(),
                    flip_x: false,
                    flip_y: false,
                    anchor: Vec2::ZERO,
                });
            };
        const ROAD_COLOR: Color = Color::rgb(0.25, 0.2, 0.1);
        let index = ecs.read_resource::<veloren_world::IndexOwned>();
        for site in data.sites.values() {
            if let Some(wsite) = site.world_site.map(|s| index.sites.get(s)) {
                let Some(wsite) = (match &wsite.kind {
                    SiteKind::Refactor(s)
                    | SiteKind::CliffTown(s)
                    | SiteKind::SavannahPit(s)
                    | SiteKind::DesertCity(s) => Some(s),
                    _ => None,
                }) else {
                    continue;
                };
                if !contains_aabr(wsite.bounds()) {
                    continue;
                }
                for plot in wsite.plots.values() {
                    let bounds = plot.find_bounds();

                    let color = match plot.kind() {
                        veloren_world::site2::PlotKind::Plaza => ROAD_COLOR,
                        veloren_world::site2::PlotKind::Bridge(_) => Color::rgb(0.5, 0.5, 0.5),
                        veloren_world::site2::PlotKind::Road(road) => {
                            for tile in road.iter() {
                                extract_aabr(
                                    wsite,
                                    vek::Aabr {
                                        min: *tile,
                                        max: *tile + 1,
                                    },
                                    ROAD_COLOR,
                                );
                            }
                            continue;
                        }
                        _ => Color::rgb(0.3, 0.3, 0.3),
                    };
                    extract_aabr(wsite, bounds, color);
                }
            }
        }
    }
}

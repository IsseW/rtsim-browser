use bevy::prelude::*;
use bevy_egui::{egui, EguiContexts};
use bevy_pancam::PanCam;
use veloren_common::rtsim::{NpcId, Role};
use veloren_rtsim::{ai::Action, data::Npcs};
use veloren_server::rtsim::RtSim;

use crate::{server::VelorenServer, SelectedNpc};

#[derive(Default)]
pub struct State {
    query_window: Option<(String, Option<Vec<NpcId>>)>,
    follow_selected: bool,
}

fn do_query(query: &str, npcs: &Npcs) -> Vec<NpcId> {
    let npc_names = &*veloren_common::npc::NPC_NAMES.read();
    let terms = query
        .split(',')
        .filter(|s| !s.is_empty())
        .map(|s| s.trim().to_lowercase())
        .collect::<Vec<_>>();

    npcs.npcs
        .iter()
        .filter(|(_, npc)| {
            let mut tags = vec![
                match &npc.role {
                    Role::Civilised(_) => "civilised".to_string(),
                    Role::Wild => "wild".to_string(),
                    Role::Monster => "monster".to_string(),
                    Role::Vehicle => "vehicle".to_string(),
                },
                format!("{:?}", npc.mode),
                npc.get_name(),
                npc_names[&npc.body].keyword.clone(),
            ];

            if let Some(proffession) = npc.profession() {
                tags.push(format!("{:?}", proffession));
            }
            if let Some(species_meta) = npc_names.get_species_meta(&npc.body) {
                tags.push(species_meta.keyword.clone());
            }

            terms
                .iter()
                .all(|term| tags.iter().any(|tag| term.eq_ignore_ascii_case(tag.trim())))
        })
        .map(|(id, _)| id)
        .collect()
}

pub fn ui(
    mut ctx: EguiContexts,
    server: NonSend<VelorenServer>,
    mut selected: ResMut<SelectedNpc>,
    mut state: Local<State>,
    mut cam: Query<&mut Transform, With<PanCam>>,
) {
    if let VelorenServer::Running { server, .. } = &*server {
        let mut cam = cam.single_mut();
        let rtsim = server.state().ecs().fetch::<RtSim>();
        let data = &*rtsim.state().data();
        egui::TopBottomPanel::top("top_panel").show(ctx.ctx_mut(), |ui| {
            egui::menu::bar(ui, |ui| {
                if ui.button("🔎 Query").clicked() {
                    if state.query_window.is_some() {
                        state.query_window = None;
                    } else {
                        state.query_window = Some(default());
                    }
                }
            });
        });
        if let Some((edit, result)) = &mut state.query_window {
            egui::Window::new("🔎 Query").show(ctx.ctx_mut(), |ui| {
                ui.horizontal(|ui| {
                    ui.label("query:");
                    let re = ui.text_edit_singleline(edit);
                    if ui.button("🔎").clicked()
                        || re.lost_focus()
                            && re.ctx.input(|input| input.key_pressed(egui::Key::Enter))
                    {
                        *result = Some(do_query(edit.as_str(), &data.npcs))
                    }
                });

                if let Some(result) = result {
                    egui::ScrollArea::vertical().show(ui, |ui| {
                        for &id in result.iter() {
                            if let Some(npc) = data.npcs.get(id) {
                                if ui.button(npc.get_name()).clicked() {
                                    selected.0 = Some(id);
                                }
                            }
                        }
                    });
                }
            });
        }
        if let Some(id) = selected.0
            && let Some(npc) = data.npcs.get(id)
        {
            egui::SidePanel::new(egui::panel::Side::Left, "npc")
                .width_range(280.0..=280.0)
                .show(ctx.ctx_mut(), |ui| {
                    ui.heading(format!("{} ({:?})", npc.get_name(), id));
                    ui.label(format!("Role: {:?}", npc.role));

                    let npc_names = &*veloren_common::npc::NPC_NAMES.read();
                    if let Some(species_meta) = npc_names.get_species_meta(&npc.body) {
                        ui.label(format!("Body: {}", species_meta.generic));
                    }

                    ui.label(format!("Seed: {}", npc.seed));
                    ui.label(format!(
                        "Pos: ({}, {}, {})",
                        npc.wpos.x.floor(),
                        npc.wpos.y.floor(),
                        npc.wpos.z.floor()
                    ));
                    ui.label(format!("Home: {:?}", npc.home));
                    ui.label(format!("Faction: {:?}", npc.faction));
                    ui.label(format!("Personality: {:#?}", npc.personality));

                    ui.heading("Status");
                    ui.label(format!("Current site: {:?}", npc.current_site));
                    ui.label(format!("Mode: {:?}", npc.mode));

                    let riding = data
                        .npcs
                        .mounts
                        .get_mount_link(id)
                        .map(|mount_link| mount_link.mount);
                    ui.horizontal(|ui| {
                        ui.label("Riding: ");
                        match riding {
                            Some(id) => {
                                if ui.button("{id:?}").clicked() {
                                    selected.0 = Some(id);
                                }
                            }
                            None => {
                                let button = egui::Button::new("None");
                                ui.add_enabled(false, button);
                            }
                        }
                    });

                    if let Some(brain) = &npc.brain {
                        ui.heading("Brain");
                        let mut bt = Vec::new();
                        brain.action.backtrace(&mut bt);
                        egui::ScrollArea::vertical().show(ui, |ui| {
                            for (i, action) in bt.into_iter().enumerate() {
                                ui.label(format!("[{i}]: {}", action));
                            }
                        });
                    }
                    ui.horizontal(|ui| {
                        ui.checkbox(&mut state.follow_selected, "Follow selected");
                        if state.follow_selected || ui.button("Center").clicked() {
                            let size = server.world().sim().get_size().as_();
                            let pos = npc.wpos.xy() - size * 16.0;
                            let pos = Vec3::new(pos.x, pos.y, 100.0);
                            cam.translation = pos;
                        }
                    });
                });
        }
    } else {
        egui::CentralPanel::default().show(ctx.ctx_mut(), |ui| {
            ui.heading("Loading...");
        });
    }
}

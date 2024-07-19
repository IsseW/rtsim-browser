## Player events

hud-chat-online_msg = { "[" }{ $name }] зашёл на сервер
hud-chat-offline_msg = { "[" }{ $name }] покинул сервер

## Buff deaths

hud-chat-died_of_pvp_buff_msg =
    .burning = { "[" }{ $victim }] сгорел вызванного [{ $attacker }]
    .bleeding = { "[" }{ $victim }] умер от кровотечения вызванного [{ $attacker }]
    .curse = { "[" }{ $victim }] умер от проклятия вызванного [{ $attacker }]
    .crippled = { "[" }{ $victim }] умер от множественных травм вызванного [{ $attacker }]
    .frozen = { "[" }{ $victim }] замёрз насмерть вызванного [{ $attacker }]
    .mysterious = { "[" }{ $victim }] загадочно умер вызванного [{ $attacker }]
hud-chat-died_of_buff_nonexistent_msg =
    .burning = { "[" }{ $victim }] сгорел
    .bleeding = { "[" }{ $victim }] умер от кровотечения
    .curse = { "[" }{ $victim }] умер от проклятия
    .crippled = { "[" }{ $victim }] умер от множественных травм
    .frozen = { "[" }{ $victim }] замёрз насмерть
    .mysterious = { "[" }{ $victim }] загадочно умер
hud-chat-died_of_npc_buff_msg =
    .burning = { "[" }{ $victim }] сгорел вызванного { $attacker }
    .bleeding = { "[" }{ $victim }] умер от кровотечения вызванного { $attacker }
    .curse = { "[" }{ $victim }] умер от проклятия вызванного { $attacker }
    .crippled = { "[" }{ $victim }] умер от множественных травм вызванного { $attacker }
    .frozen = { "[" }{ $victim }] замёрз насмерть вызванного { $attacker }
    .mysterious = { "[" }{ $victim }] загадочно умер вызванного { $attacker }

## PvP deaths

hud-chat-pvp_melee_kill_msg = { "[" }{ $attacker }] одержал победу над [{ $victim }]
hud-chat-pvp_ranged_kill_msg = { "[" }{ $attacker }] застрелил [{ $victim }]
hud-chat-pvp_explosion_kill_msg = { "[" }{ $attacker }] взорвал [{ $victim }]
hud-chat-pvp_energy_kill_msg = { "[" }{ $attacker }] убил [{ $victim }] магией
hud-chat-pvp_other_kill_msg = { "[" }{ $attacker }] убил [{ $victim }]

## PvE deaths

hud-chat-npc_melee_kill_msg = { $attacker } убил [{ $victim }]
hud-chat-npc_ranged_kill_msg = { $attacker } застрелил [{ $victim }]
hud-chat-npc_explosion_kill_msg = { $attacker } взорвал [{ $victim }]
hud-chat-npc_energy_kill_msg = { $attacker } убил [{ $victim }] магией
hud-chat-npc_other_kill_msg = { $attacker } убил [{ $victim }]

## Other deaths

hud-chat-fall_kill_msg = { "[" }{ $name }] умер от падения
hud-chat-suicide_msg = { "[" }{ $name }] умер от ран, нанесённых самому себе
hud-chat-default_death_msg = { "[" }{ $name }] умер

## Utils

hud-chat-all = Все
hud-chat-chat_tab_hover_tooltip = ПКМ для настроек
hud-loot-pickup-msg-you =
    { $amount ->
        [1] Вы подобрали { $item }
       *[other] Вы подобрали { $amount }x { $item }
    }
hud-loot-pickup-msg =
    { $gender ->
        [she]
            { $amount ->
                [1] { $actor } подобрала { $item }
               *[other] { $actor } подобрала { $amount }x { $item }
            }
       *[he]
            { $amount ->
                [1] { $actor } подобрал { $item }
               *[other] { $actor } подобрал { $amount }x { $item }
            }
    }
hud-chat-goodbye = До свидания!
hud-chat-connection_lost = Соединение потеряно. Выход через { $time } секунд.
# Npc /tell messages, no gender info, sadly
hud-chat-tell-from-npc = От [{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-tell-to = К [{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-tell-from = От [{ $alias }]: { $msg }
# Npc /tell messages, no gender info, sadly
hud-chat-tell-to-npc = К [{ $alias }]: { $msg }

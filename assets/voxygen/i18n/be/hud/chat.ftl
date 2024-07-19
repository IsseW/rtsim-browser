hud-chat-all = Усе
hud-chat-chat_tab_hover_tooltip = ПКМ для наладаў
hud-chat-online_msg = { "[" }{ $name }] зайшоў у сетку.
hud-chat-offline_msg = { "[" }{ $name }] больш не ў сетцы.
hud-chat-default_death_msg = { "[" }{ $name }] памёр(-ла)
hud-chat-fall_kill_msg = { "[" }{ $name }] разбіўся(-лася) насмерць
hud-chat-suicide_msg = { "[" }{ $name }] здзейсніў(-ла) самагубства
hud-chat-died_of_pvp_buff_msg =
    .burning = { "[" }{ $victim }] згарэў(-ла) жыўцом, выкліканага [{ $attacker }]
    .bleeding = { "[" }{ $victim }] памёр(-ла) ад крывацёку, выкліканага [{ $attacker }]
    .curse = { "[" }{ $victim }] памёр(-ла) ад праклёну, выкліканага [{ $attacker }]
    .crippled = { "[" }{ $victim }] памёр(-ла) ад траўмаў, выкліканага [{ $attacker }]
    .frozen = { "[" }{ $victim }] памёр(-ла) ад холаду, выкліканага [{ $attacker }]
hud-chat-pvp_melee_kill_msg = { "[" }{ $attacker }] перамог(-ла) [{ $victim }]
hud-chat-pvp_ranged_kill_msg = { "[" }{ $attacker }] застрэліў(-ла) [{ $victim }]
hud-chat-pvp_explosion_kill_msg = { "[" }{ $attacker }] падарваў(-ла) [{ $victim }]
hud-chat-pvp_energy_kill_msg = { "[" }{ $attacker }] забіў(-ла) [{ $victim }] чарамі
hud-chat-died_of_buff_nonexistent_msg =
    .burning = { "[" }{ $victim }] згарэў(-ла) жыўцом
    .bleeding = { "[" }{ $victim }] памёр(-ла) ад крывацёку
    .curse = { "[" }{ $victim }] памёр(-ла) ад праклёну
    .crippled = { "[" }{ $victim }] памёр(-ла) ад траўмаў
    .frozen = { "[" }{ $victim }] памёр(-ла) ад холаду
hud-chat-died_of_npc_buff_msg =
    .burning = { "[" }{ $victim }] згарэў(-ла) жыўцом, выкліканага { $attacker }
    .bleeding = { "[" }{ $victim }] памёр(-ла) ад крывацёку, выкліканага { $attacker }
    .curse = { "[" }{ $victim }] памёр(-ла) ад праклёну, выкліканага { $attacker }
    .crippled = { "[" }{ $victim }] памёр(-ла) ад траўмаў, выкліканага { $attacker }
    .frozen = { "[" }{ $victim }] памёр(-ла) ад холаду, выкліканага { $attacker }
hud-chat-npc_melee_kill_msg = { $attacker } забіў(-ла) [{ $victim }]
hud-chat-npc_ranged_kill_msg = { $attacker } застрэліў(-ла) [{ $victim }]
hud-chat-npc_explosion_kill_msg = { $attacker } падарваў(-ла) [{ $victim }]
hud-chat-npc_energy_kill_msg = { $attacker } забіў(-ла) [{ $victim }] чарамі
hud-chat-npc_other_kill_msg = { $attacker } забіў(-ла) [{ $victim }]
hud-chat-goodbye = Да пабачэння!
hud-chat-connection_lost = Злучэнне згублена. Вас выштурхнуць праз { $time } сек.
# Generic messages
hud-chat-message-in-group-with-name = ({ $group }) [{ $alias }] { $name }: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-tell-to = Да [{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-tell-from = Ад [{ $alias }]: { $msg }
# Other PvP deaths, both $attacker_gender and $victim_gender are available
hud-chat-pvp_other_kill_msg = { "[" }{ $attacker }] забіў [{ $victim }]
# HUD Pickup message
hud-loot-pickup-msg-you =
    { $amount ->
        [1] Вы падвбралі { $item }
       *[other] Вы падвбралі { $amount }x { $item }
    }
# HUD Pickup message
hud-loot-pickup-msg =
    { $gender ->
        [she]
            { $amount ->
                [1] { $actor } падабрала { $item }
               *[other] { $actor } падабрала { $amount }x { $item }
            }
       *[he]
            { $amount ->
                [1] { $actor } падвбраў { $item }
               *[other] { $actor } падабраў { $amount }x { $item }
            }
    }
# Npc /tell messages, no gender info, sadly
hud-chat-tell-to-npc = Да [{ $alias }]: { $msg }
# Npc /tell messages, no gender info, sadly
hud-chat-tell-from-npc = Ад [{ $alias }]: { $msg }
# Generic messages
hud-chat-message-with-name = { "[" }{ $alias }] { $name }: { $msg }
# Generic messages
hud-chat-message-in-group = ({ $group }) [{ $alias }]: { $msg }
# Generic messages
hud-chat-message = { "[" }{ $alias }]: { $msg }

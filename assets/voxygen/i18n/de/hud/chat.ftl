## Utils

hud-chat-all = Alle
hud-chat-chat_tab_hover_tooltip = Rechtsklick für Einstellungen
hud-loot-pickup-msg =
    { $actor } nahm { $amount ->
        [1] { $item }
       *[other] { $amount }x { $item }
    } auf

## Player events

hud-chat-online_msg = { "[" }{ $name }] ist nun online.
hud-chat-offline_msg = { "[" }{ $name }] ging offline.

## Other deaths

hud-chat-default_death_msg = { "[" }{ $name }] starb
hud-chat-fall_kill_msg = { "[" }{ $name }] starb durch Fallschaden
hud-chat-suicide_msg = { "[" }{ $name }] beging Selbstmord

## Buff, PvE, PvP deaths

hud-chat-died_of_pvp_buff_msg =
    .burning = { "[" }{ $victim }] wurde von [{ $attacker }] verbrannt.
    .bleeding = { "[" }{ $victim }] ist durch [{ $attacker }] verblutet.
    .curse = { "[" }{ $victim }] starb an einem Fluch von [{ $attacker }].
    .crippled = { "[" }{ $victim }] starb an Verkrüpplung durch [{ $attacker }].
    .frozen = { "[" }{ $victim }] ist durch [{ $attacker }] erfroren.
    .mysterious = { "[" }{ $victim }] starb unter geheimnisvollen Umständen durch [{ $attacker }].
hud-chat-pvp_melee_kill_msg = { "[" }{ $attacker }] vernichtete [{ $victim }]
hud-chat-pvp_ranged_kill_msg = { "[" }{ $attacker }] erschoss [{ $victim }]
hud-chat-pvp_explosion_kill_msg = { "[" }{ $attacker }] sprengte [{ $victim }] aus dem Leben
hud-chat-pvp_energy_kill_msg = { "[" }{ $attacker }] tötete [{ $victim }] mit Magie
hud-chat-pvp_other_kill_msg = { "[" }{ $attacker }] tötete [{ $victim }]
hud-chat-died_of_buff_nonexistent_msg =
    .burning = { "[" }{ $victim }] ist verbrannt.
    .bleeding = { "[" }{ $victim }] ist verblutet.
    .curse = { "[" }{ $victim }] starb an Verfluchung.
    .crippled = { "[" }{ $victim }] starb an Verkrüppelung.
    .frozen = { "[" }{ $victim }] ist erfroren.
    .mysterious = { "[" }{ $victim }] ist unter geheimnisvollen Umständen gestorben.
hud-chat-died_of_npc_buff_msg =
    .burning = { "[" }{ $victim }] wurde von { $attacker } verbrannt.
    .bleeding = { "[" }{ $victim }] ist durch { $attacker } verblutet.
    .curse = { "[" }{ $victim }] starb an einem Fluch von { $attacker }.
    .crippled = { "[" }{ $victim }] starb an Verkrüpplung durch { $attacker }.
    .frozen = { "[" }{ $victim }] ist durch { $attacker } erfroren.
    .mysterious = { "[" }{ $victim }] starb unter geheimnisvollen Umständen durch { $attacker }.
hud-chat-npc_melee_kill_msg = { $attacker } tötete [{ $victim }]
hud-chat-npc_ranged_kill_msg = { $attacker } erschoss [{ $victim }]
hud-chat-npc_explosion_kill_msg = { $attacker } sprengte [{ $victim }] aus dem Leben
hud-chat-npc_energy_kill_msg = { $attacker } tötete [{ $victim }] mit Magie
hud-chat-npc_other_kill_msg = { $attacker } tötete [{ $victim }]
hud-chat-goodbye = Auf Wiedersehen!
hud-chat-connection_lost = Verbindungsabbruch. Du wirst in { $time } Sekunden gekickt.
# Player /tell messages, $user_gender should be available
hud-chat-tell-to-npc = An [{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-message-with-name = { "[" }{ $alias }] { $name }: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-message-in-group = ({ $group }) [{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-message = { "[" }{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-tell-to = An [{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-tell-from-npc = Von [{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-tell-from = Von [{ $alias }]: { $msg }
# Player /tell messages, $user_gender should be available
hud-chat-message-in-group-with-name = ({ $group }) [{ $alias }] { $name }: { $msg }
# HUD Pickup message
hud-loot-pickup-msg-you =
    Du nahmst { $amount ->
        [1] { $item }
       *[other] { $amount }x { $item }
    } auf

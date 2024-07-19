## Internal terms, currently only used in es
## If we remove them here, they also get auto-removed in es,
## so please keep them, even when not used in English file.
## See https://github.com/WeblateOrg/weblate/issues/9895
-hud-skill-sc_wardaura_title = ""
-hud-skill-bow_shotgun_title = ""
-hud-skill-st_shockwave_title = ""

## Skill tree UI
hud-rank_up = New skill point
hud-skill-sp_available =
    { $number ->
        [0] No skill points available
        [1] { $number } skill point available
        *[other] { $number } skill points available
    }
hud-skill-not_unlocked = Not yet unlocked
hud-skill-req_sp = {"\u000A"}Requires { $number } SP
hud-skill-set_as_exp_bar = Track progress on experience bar

hud-skill-unlck_sword_title = Sword proficiency
hud-skill-unlck_sword = Unlocks the sword skill tree.{ $SP }
hud-skill-unlck_axe_title = Axe proficiency
hud-skill-unlck_axe = Unlocks the axe skill tree.{ $SP }
hud-skill-unlck_hammer_title = Hammer proficiency
hud-skill-unlck_hammer = Unlocks the hammer skill tree.{ $SP }
hud-skill-unlck_bow_title = Bow proficiency
hud-skill-unlck_bow = Unlocks the bow skill tree.{ $SP }
hud-skill-unlck_staff_title = Staff proficiency
hud-skill-unlck_staff = Unlocks the staff skill tree.{ $SP }
hud-skill-unlck_sceptre_title = Sceptre proficiency
hud-skill-unlck_sceptre = Unlocks the sceptre skill tree.{ $SP }
hud-skill-climbing_title = Climbing
hud-skill-climbing = Ability to climb surfaces.
hud-skill-climbing_cost_title = Climbing Cost
hud-skill-climbing_cost = Climbing uses { $boost } % less energy.{ $SP }
hud-skill-climbing_speed_title = Climbing Speed
hud-skill-climbing_speed = Climb { $boost } % faster.{ $SP }
hud-skill-swim_title = Swimming
hud-skill-swim = Moving through water.
hud-skill-swim_speed_title = Swimming Speed
hud-skill-swim_speed = Swim { $boost } % faster.{ $SP }
hud-skill-sc_lifesteal_title = Lifesteal Beam
hud-skill-sc_lifesteal = Drain the life from your enemies.
hud-skill-sc_lifesteal_damage_title = Damage
hud-skill-sc_lifesteal_damage = Deal { $boost } % more damage.{ $SP }
hud-skill-sc_lifesteal_range_title = Range
hud-skill-sc_lifesteal_range = Your beam reaches { $boost } % further.{ $SP }
hud-skill-sc_lifesteal_lifesteal_title = Lifesteal
hud-skill-sc_lifesteal_lifesteal = Convert an additional { $boost } % of damage into health.{ $SP }
hud-skill-sc_lifesteal_regen_title = Energy Regen
hud-skill-sc_lifesteal_regen = Replenish your energy by an additional { $boost } %.{ $SP }
hud-skill-sc_heal_title = Healing Aura
hud-skill-sc_heal = Heal your allies using the blood of your enemies, requires combo to activate.
hud-skill-sc_heal_heal_title = Heal
hud-skill-sc_heal_heal = Increases the amount you heal by { $boost } %.{ $SP }
hud-skill-sc_heal_cost_title = Energy Cost
hud-skill-sc_heal_cost = Healing requires { $boost } % less energy.{ $SP }
hud-skill-sc_heal_duration_title = Duration
hud-skill-sc_heal_duration = The effects of your healing aura last { $boost } % longer.{ $SP }
hud-skill-sc_heal_range_title = Radius
hud-skill-sc_heal_range = Your healing aura reaches { $boost } % further.{ $SP }
hud-skill-sc_wardaura_unlock_title = Warding Aura Unlock
hud-skill-sc_wardaura_unlock = Allows you to ward your allies against enemy attacks.{ $SP }
hud-skill-sc_wardaura_strength_title = Strength
hud-skill-sc_wardaura_strength = The strength of your protection increases by { $boost } %.{ $SP }
hud-skill-sc_wardaura_duration_title = Duration
hud-skill-sc_wardaura_duration = The effects of your ward last { $boost } % longer.{ $SP }
hud-skill-sc_wardaura_range_title = Radius
hud-skill-sc_wardaura_range = Your ward reaches { $boost } % further.{ $SP }
hud-skill-sc_wardaura_cost_title = Energy Cost
hud-skill-sc_wardaura_cost = Creating the ward requires { $boost } % less energy.{ $SP }
hud-skill-st_shockwave_range_title = Shockwave Range
hud-skill-st_shockwave_range = Throw things that used to be out of reach, range increased { $boost } %.{ $SP }
hud-skill-st_shockwave_cost_title = Shockwave Cost
hud-skill-st_shockwave_cost = Decreases the energy cost to throw helpless villagers by { $boost } %.{ $SP }
hud-skill-st_shockwave_knockback_title = Shockwave Knockback
hud-skill-st_shockwave_knockback = Increases throw potential by { $boost } %.{ $SP }
hud-skill-st_shockwave_damage_title = Shockwave Damage
hud-skill-st_shockwave_damage = Increases the damage done by { $boost } %.{ $SP }
hud-skill-st_shockwave_unlock_title = Shockwave Unlock
hud-skill-st_shockwave_unlock = Unlocks the ability to throw enemies away using fire.{ $SP }
hud-skill-st_flamethrower_title = Flamethrower
hud-skill-st_flamethrower = Throws fire, cook'em all.
hud-skill-st_flame_velocity_title = Flame Velocity
hud-skill-st_flame_velocity = Gets the fire there faster, { $boost } % faster.{ $SP }
hud-skill-st_flamethrower_range_title = Flamethrower Range
hud-skill-st_flamethrower_range = For when the flames just won't reach, they go { $boost } % further.{ $SP }
hud-skill-st_energy_drain_title = Energy Drain
hud-skill-st_energy_drain = Decreases the rate energy is drained by { $boost } %.{ $SP }
hud-skill-st_flamethrower_damage_title = Flamethrower Damage
hud-skill-st_flamethrower_damage = Increases damage by { $boost } %.{ $SP }
hud-skill-st_explosion_radius_title = Explosion Radius
hud-skill-st_explosion_radius = Bigger is better, increases explosion radius by { $boost } %.{ $SP }
hud-skill-st_energy_regen_title = Energy Regen
hud-skill-st_energy_regen = Increases energy gain by { $boost } %.{ $SP }
hud-skill-st_fireball_title = Fireball
hud-skill-st_fireball = Shoots a fireball that explodes on impact.
hud-skill-st_damage_title = Damage
hud-skill-st_damage = Increases damage by { $boost } %.{ $SP }
hud-skill-bow_projectile_speed_title = Projectile Speed
hud-skill-bow_projectile_speed = Allows you to shoot arrows further, faster, by { $boost } %.{ $SP }
hud-skill-bow_charged_title = Charged Shoot
hud-skill-bow_charged = Because you waited longer.
hud-skill-bow_charged_damage_title = Charged Damage
hud-skill-bow_charged_damage = Increases damage by { $boost } %.{ $SP }
hud-skill-bow_charged_energy_regen_title = Charged Regen
hud-skill-bow_charged_energy_regen = Increases energy recovery by { $boost } %.{ $SP }
hud-skill-bow_charged_knockback_title = Charged Knockback
hud-skill-bow_charged_knockback = Knock enemies further back by { $boost } %.{ $SP }
hud-skill-bow_charged_speed_title = Charged Speed
hud-skill-bow_charged_speed = Increases the rate that you charge the attack by { $boost } %.{ $SP }
hud-skill-bow_charged_move_title = Charged Move Speed
hud-skill-bow_charged_move = Increases how fast you can shuffle while charging the attack by { $boost } %.{ $SP }
hud-skill-bow_repeater_title = Repeater
hud-skill-bow_repeater = Shoots faster the longer you fire for.
hud-skill-bow_repeater_damage_title = Repeater Damage
hud-skill-bow_repeater_damage = Increases the damage done by { $boost } %.{ $SP }
hud-skill-bow_repeater_cost_title = Repeater Cost
hud-skill-bow_repeater_cost = Decreases the energy cost to become a repeater by { $boost } %.{ $SP }
hud-skill-bow_repeater_speed_title = Repeater Speed
hud-skill-bow_repeater_speed = Increases the rate at which you fire arrows by { $boost } %.{ $SP }
hud-skill-bow_shotgun_unlock_title = Unlocks Shotgun
hud-skill-bow_shotgun_unlock = Unlocks ability to fire multiple arrows at once.{ $SP }
hud-skill-bow_shotgun_damage_title = Shotgun Damage
hud-skill-bow_shotgun_damage = Increases the damage done by { $boost } %.{ $SP }
hud-skill-bow_shotgun_cost_title = Shotgun Cost
hud-skill-bow_shotgun_cost = Decreases the cost of shotgun by { $boost } %.{ $SP }
hud-skill-bow_shotgun_arrow_count_title = Shotgun Arrows
hud-skill-bow_shotgun_arrow_count = Increases the number of arrows in the burst by { $boost }.{ $SP }
hud-skill-bow_shotgun_spread_title = Shotgun Spread
hud-skill-bow_shotgun_spread = Decreases the spread of the arrows by { $boost } %.{ $SP }
hud-skill-mining_title = Mining
hud-skill-pick_strike_title = Pickaxe Strike
hud-skill-pick_strike = Hit rocks with the pickaxe to gain ore, gems and experience.
hud-skill-pick_strike_speed_title = Pickaxe Strike Speed
hud-skill-pick_strike_speed = Mine rocks faster.{ $SP }
hud-skill-pick_strike_oregain_title = Pickaxe Strike Ore Yield
hud-skill-pick_strike_oregain = Chance to gain extra ore ({ $boost } % per level).{ $SP }
hud-skill-pick_strike_gemgain_title = Pickaxe Strike Gem Yield
hud-skill-pick_strike_gemgain = Chance to gain extra gems ({ $boost } % per level).{ $SP }

## Skill tree error dialog
hud-skill-persistence-hash_mismatch = There was a difference detected in one of your skill groups since you last played.
hud-skill-persistence-deserialization_failure = There was a error in loading some of your skills from the database.
hud-skill-persistence-spent_experience_missing = The amount of free experience you had in one of your skill groups differed from when you last played.
hud-skill-persistence-skills_unlock_failed = Your skills were not able to be obtained in the same order you acquired them. Prerequisites or costs may have changed.
hud-skill-persistence-common_message = Some of your skill points have been reset. You will need to reassign them.

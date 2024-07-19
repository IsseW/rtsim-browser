## General - Todos los árboles de habilidades

hud-rank_up = Nuevo punto de habilidad adquirido
hud-skill-sp_available =
    { $number ->
        [0] Sin puntos de habilidad disponibles
        [one] { $number } punto de habilidad disponible
       *[other] { $number } puntos de habilidad disponibles
    }
hud-skill-not_unlocked = Bloqueado
hud-skill-req_sp =
    { "\u000A" } Requiere { $number ->
        [one] { $number } punto de habilidad
       *[other] { $number } puntos de habilidad
    }
hud-skill-set_as_exp_bar = Mostrar progreso en barra de experiencia

# Combate general - Árbol de habilidades


## Salud


## Energía


## Competencia con armas

hud-skill-unlck_sword_title = Competencia con espadas
hud-skill-unlck_sword = Desbloquea el árbol de habilidades de la espada.{ $SP }
hud-skill-unlck_axe_title = Competencia con hachas
hud-skill-unlck_axe = Desbloquea el árbol de habilidades del hacha.{ $SP }
hud-skill-unlck_hammer_title = Competencia con martillos
hud-skill-unlck_hammer = Desbloquea el árbol de habilidades del martillo.{ $SP }
hud-skill-unlck_bow_title = Competencia con arcos
hud-skill-unlck_bow = Desbloquea el árbol de habilidades del arco.{ $SP }
hud-skill-unlck_staff_title = Competencia con bastones
hud-skill-unlck_staff = Desbloquea el árbol de habilidades del bastón.{ $SP }
hud-skill-unlck_sceptre_title = Competencia con cetros
hud-skill-unlck_sceptre = Desbloquea el árbol de habilidades del cetro.{ $SP }

## Esquiva


## Escalada

hud-skill-climbing_title = Escalar
hud-skill-climbing = Subir pendientes y trepar a grandes alturas.
hud-skill-climbing_cost_title = Coste de energía para escalar
hud-skill-climbing_cost = Escalar consume un { $boost } % menos de energía.{ $SP }
hud-skill-climbing_speed_title = Velocidad de escalada
hud-skill-climbing_speed = Escalas un { $boost } % más rápido.{ $SP }

## Nado

hud-skill-swim_title = Nadar
hud-skill-swim = Movimiento acuático.
hud-skill-swim_speed_title = Velocidad al nadar
hud-skill-swim_speed = Nadas un { $boost } % más rápido.{ $SP }

# Cetro - Árbol de habilidades


## Drenar vida

hud-skill-sc_lifesteal_title = Drenar vida
hud-skill-sc_lifesteal = Lanza un rayo que absorbe la esencia vital de los enemigos.
hud-skill-sc_lifesteal_damage_title = Daño
hud-skill-sc_lifesteal_damage = El rayo hace un { $boost } % más de daño.{ $SP }
hud-skill-sc_lifesteal_regen_title = Regeneración de energía
hud-skill-sc_lifesteal_regen = Recupera un { $boost } % de energía adicional.{ $SP }
hud-skill-sc_lifesteal_range_title = Alcance
hud-skill-sc_lifesteal_range = El rayo llega un { $boost } % más lejos.{ $SP }
hud-skill-sc_lifesteal_lifesteal_title = Robo de vida
hud-skill-sc_lifesteal_lifesteal = Convierte un { $boost } % adicional del daño infligido en salud.{ $SP }

## Campo de vida

hud-skill-sc_heal_title = Campo vital
hud-skill-sc_heal = Emana de ti un aura curativa que usa la esencia vital absorbida.
hud-skill-sc_heal_heal_title = Potencia de {{ hud-skill-sc_heal_title }}
hud-skill-sc_heal_heal = Aumenta la curación que haces en un { $boost } %.{ $SP }
hud-skill-sc_heal_cost_title = Coste de {{ hud-skill-sc_heal_title }}
hud-skill-sc_heal_cost = Curar consume un { $boost } % menos de energía.{ $SP }
hud-skill-sc_heal_duration_title = Duración de {{ hud-skill-sc_heal_title }}
hud-skill-sc_heal_duration = Los efectos del aura duran un { $boost } % más.{ $SP }
hud-skill-sc_heal_range_title = Alcance de {{ hud-skill-sc_heal_title }}
hud-skill-sc_heal_range = El aura llega un { $boost } % más lejos.{ $SP }

## Aura de protección

-hud-skill-sc_wardaura_title = Aura del guardián
hud-skill-sc_wardaura_unlock_title = Desbloquear {{ -hud-skill-sc_wardaura_title }}
hud-skill-sc_wardaura_unlock = Emana de ti un aura que te protege a ti y a tus aliados.{ $SP }
hud-skill-sc_wardaura_strength_title = Potencia de {{ -hud-skill-sc_wardaura_title }}
hud-skill-sc_wardaura_strength = La potencia de la protección aumenta en un { $boost } %.{ $SP }
hud-skill-sc_wardaura_duration_title = Duración de {{ -hud-skill-sc_wardaura_title }}
hud-skill-sc_wardaura_duration = Los efectos de la protección duran un { $boost } % más.{ $SP }
hud-skill-sc_wardaura_range_title = Alcance de {{ -hud-skill-sc_wardaura_title }}
hud-skill-sc_wardaura_range = El aura llega un { $boost } % más lejos.{ $SP }
hud-skill-sc_wardaura_cost_title = Coste de energía de {{ -hud-skill-sc_wardaura_title }}
hud-skill-sc_wardaura_cost = El aura requiere un { $boost } % menos de energía.{ $SP }

# Árco - Árbol de habilidades


## Tiro de arco

hud-skill-bow_charged_title = Tiro de arco
hud-skill-bow_charged = Tensa tu arco para disparar una flecha.
hud-skill-bow_charged_damage_title = Daño de {{ hud-skill-bow_charged_title }}
hud-skill-bow_charged_damage = Aumenta el daño infligido en un { $boost } %.{ $SP }
hud-skill-bow_charged_speed_title = Velocidad de {{ hud-skill-bow_charged_title }}
hud-skill-bow_charged_speed = Aumenta la velocidad a la que tensas el arco en un { $boost } %.{ $SP }
hud-skill-bow_charged_knockback_title = Retroceso de {{ hud-skill-bow_charged_title }}
hud-skill-bow_charged_knockback = Las flechas hacen retroceder a los enemigos un { $boost } % más.{ $SP }

## Metralleta

hud-skill-bow_repeater_title = Metralleta
hud-skill-bow_repeater = Dispara una serie de flechas que van aumentando de velocidad.
hud-skill-bow_repeater_damage_title = Daño de {{ hud-skill-bow_repeater_title }}
hud-skill-bow_repeater_damage = Aumenta el daño infligido en un { $boost } %.{ $SP }
hud-skill-bow_repeater_cost_title = Coste de {{ hud-skill-bow_repeater_title }}
hud-skill-bow_repeater_cost = Reduce el coste de energía al empezar una ráfaga en un { $boost } %.{ $SP }
hud-skill-bow_repeater_speed_title = Velocidad de {{ hud-skill-bow_repeater_title }}
hud-skill-bow_repeater_speed = Aumenta la velocidad a la que se disparan flechas en un { $boost } %.{ $SP }

## Escopeta

-hud-skill-bow_shotgun_title = Escopeta
hud-skill-bow_shotgun_unlock_title = Desbloquear Escopeta
hud-skill-bow_shotgun_unlock = Desbloquea la capacidad de disparar una multitud de flechas al mismo tiempo.{ $SP }
hud-skill-bow_shotgun_damage_title = Daño de {{ -hud-skill-bow_shotgun_title }}
hud-skill-bow_shotgun_damage = Aumenta el daño infligido en un { $boost } %.{ $SP }
hud-skill-bow_shotgun_spread_title = Dispersión de {{ -hud-skill-bow_shotgun_title }}
hud-skill-bow_shotgun_spread = Reduce la dispersión de las flechas en un { $boost } %.{ $SP }
hud-skill-bow_shotgun_cost_title = Coste de {{ -hud-skill-bow_shotgun_title }}
hud-skill-bow_shotgun_cost = Reduce el coste de escopeta en un { $boost } %.{ $SP }
hud-skill-bow_shotgun_arrow_count_title = Flechas de {{ -hud-skill-bow_shotgun_title }}
hud-skill-bow_shotgun_arrow_count = Aumenta el número de flechas por disparo en { $boost }.{ $SP }

## Velocidad de proyectil

hud-skill-bow_projectile_speed_title = Velocidad de proyectil
hud-skill-bow_projectile_speed = Las flechas llegan más lejos al viajar un { $boost } % más rápido.{ $SP }

# Bastón de fuego - Árbol de habilidades


## Bola de fuego

hud-skill-st_fireball_title = Bola de Fuego
hud-skill-st_fireball = Dispara una bola de fuego que explota al impactar.
hud-skill-st_damage_title = Daño de {{ hud-skill-st_fireball_title }}
hud-skill-st_damage = Aumenta el daño infligido en un { $boost } %.{ $SP }
hud-skill-st_explosion_radius_title = Radio de explosión de {{ hud-skill-st_fireball_title }}
hud-skill-st_explosion_radius = Aumenta el alcance de la explosión en un { $boost } %.{ $SP }
hud-skill-st_energy_regen_title = Ganancia de energía de {{ hud-skill-st_fireball_title }}
hud-skill-st_energy_regen = Aumenta la ganancia de energía en un { $boost } %.{ $SP }

## Lanzallamas

hud-skill-st_flamethrower_title = Lanzallamas
hud-skill-st_flamethrower = Lanza fuego, fríelos a todos.
hud-skill-st_flamethrower_damage_title = Daño de {{ hud-skill-st_flamethrower_title }}
hud-skill-st_flamethrower_damage = Aumenta el daño infligido en un { $boost } %.{ $SP }
hud-skill-st_flame_velocity_title = Velocidad de {{ hud-skill-st_flamethrower_title }}
hud-skill-st_flame_velocity = El fuego viaja un { $boost } % más rápido.{ $SP }
hud-skill-st_energy_drain_title = Consumo de energía de {{ hud-skill-st_flamethrower_title }}
hud-skill-st_energy_drain = La energía se reduce un { $boost } % más lenta.{ $SP }
hud-skill-st_flamethrower_range_title = Alcance de {{ hud-skill-st_flamethrower_title }}
hud-skill-st_flamethrower_range = Las llamas llegan un { $boost } % más lejos.{ $SP }

## Onda de choque

-hud-skill-st_shockwave_title = Onda de choque
hud-skill-st_shockwave_unlock_title = Desbloquear {{ -hud-skill-st_shockwave_title }}
hud-skill-st_shockwave_unlock = Desbloquea la habilidad de lanzar por los aires a los enemigos usando fuego.{ $SP }
hud-skill-st_shockwave_damage_title = Daño de {{ -hud-skill-st_shockwave_title }}
hud-skill-st_shockwave_damage = Aumenta el daño infligido en un { $boost } %.{ $SP }
hud-skill-st_shockwave_range_title = Alcance de {{ -hud-skill-st_shockwave_title }}
hud-skill-st_shockwave_range = Aumenta el alcance de la onda en un { $boost } %.{ $SP }
hud-skill-st_shockwave_knockback_title = Retroceso de {{ -hud-skill-st_shockwave_title }}
hud-skill-st_shockwave_knockback = Aumenta la potencia de lanzamiento en un { $boost } %.{ $SP }
hud-skill-st_shockwave_cost_title = Coste de {{ -hud-skill-st_shockwave_title }}
hud-skill-st_shockwave_cost = Reduce el coste de energía en un { $boost } %.{ $SP }

# Minería - Árbol de habilidades

hud-skill-mining_title = Minería
hud-skill-pick_strike_title = Picar
hud-skill-pick_strike = Usa el pico para extraer minerales y gemas de rocas y conseguir puntos de experiencia.
hud-skill-pick_strike_speed_title = Velocidad de {{ hud-skill-pick_strike_title }}
hud-skill-pick_strike_speed = Pica rocas más rápido.{ $SP }
hud-skill-pick_strike_oregain_title = Producción de minerales de {{ hud-skill-pick_strike_title }}
hud-skill-pick_strike_oregain = Concede un { $boost } % de probabilidad de conseguir minerales adicionales.{ $SP }
hud-skill-pick_strike_gemgain_title = Producción de gemas de {{ hud-skill-pick_strike_title }}
hud-skill-pick_strike_gemgain = Concede un { $boost } % de probabilidad de conseguir gemas adicionales.{ $SP }
# Skill tree UI
hud-skill-bow_charged_move_title = Velocidad de movimiento mejorada
# Skill tree UI
hud-skill-bow_charged_energy_regen = Aumenta la regeneración de energía en un { $boost } %.{ $SP }
# Skill tree UI
hud-skill-bow_charged_move = Aumenta la velocidad de movimiento en un { $boost } % mientras cargas un ataque.{ $SP }
# Skill tree UI
hud-skill-bow_charged_energy_regen_title = Regeneración mejorada

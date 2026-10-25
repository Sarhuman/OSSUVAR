class_name LateralRules
extends Resource
## Valores provisórios de LATERAL-00; sem aprovação de campanha.

@export var speed: float = 230.0
@export var enemy_speed: float = 95.0
@export var gravity: float = 1400.0
@export var jump_velocity: float = -560.0
@export var body_size: Vector2 = Vector2(22, 48)
@export var hit_height: float = 34.0
@export var fall_y: float = 810.0
@export var patrol_limits: Vector2 = Vector2(450, 590)
@export var player_health: float = 100.0
@export var enemy_health: float = 48.0
@export var player_damage: int = 16
@export var enemy_damage: int = 12
@export var player_reach: float = 58.0
@export var enemy_reach: float = 46.0
@export var aggro: float = 320.0
@export var player_prepare: float = 0.16
@export var enemy_prepare: float = 0.55
@export var active: float = 0.10
@export var player_recovery: float = 0.24
@export var enemy_recovery: float = 0.60
@export var seed_value: int = 1314


func offense(damage: int) -> ArenaRules:
	# Adapter mínimo: Stats existente exige ArenaRules; sem copiar ArenaRun.
	var definition: ArenaRules = ArenaRules.new()
	definition.player_damage = damage
	definition.skill_damage_bonus = 0
	return definition

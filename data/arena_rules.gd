class_name ArenaRules
extends Resource
## Balanceamento provisório exclusivo da arena; não é o catálogo do MVP.

@export var seed_value: int = 1314
@export var size: int = 24
@export var enemy_count: int = 10
@export var health: float = 120.0
@export var mana: float = 70.0
@export var vigor: float = 100.0
@export var player_speed: float = 3.8
@export var enemy_speed: float = 1.45
@export var enemy_health: float = 36.0
@export var player_damage: int = 16
@export var enemy_damage: int = 7
@export var attack_frames: int = 16
@export var enemy_attack_frames: int = 30
@export var skill_frames: int = 38
@export var skill_cost: float = 18.0
@export var skill_radius: float = 2.5
@export var aggro_radius: float = 6.0
@export var xp_per_enemy: int = 25
@export var xp_per_level: int = 75
@export var inventory_capacity: int = 12

class_name LateralSession
extends RefCounted
## Uma prova possui Health/Stats/contexto próprios; reinício substitui a sessão.

var player: LateralFighter
var enemy: LateralFighter
var boss: LateralFighter
var rng_context: RngContext


func _init(rules: LateralRules) -> void:
	player = LateralFighter.new(
		rules.player_health,
		rules.offense(rules.player_damage),
		rules.player_prepare,
		rules.active,
		rules.player_recovery
	)
	enemy = LateralFighter.new(
		rules.enemy_health,
		rules.offense(rules.enemy_damage),
		rules.enemy_prepare,
		rules.active,
		rules.enemy_recovery
	)
	boss = LateralFighter.new(
		rules.boss_health,
		rules.offense(rules.boss_damage),
		rules.boss_prepare,
		rules.active,
		rules.boss_recovery
	)
	rng_context = Rng.create_context("lateral_probe", rules.seed_value)

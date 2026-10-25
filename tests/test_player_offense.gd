extends GutTest

const RULES: Resource = preload("res://data/arena_rules.tres")


func test_repeated_equip_changes_only_basic_damage_in_actual_combat() -> void:
	var plain: ArenaRun = ArenaRun.new(RULES as ArenaRules)
	var equipped: ArenaRun = ArenaRun.new(RULES as ArenaRules)
	equipped.inventory.append("Ferro funerário")
	for i: int in 5:
		equipped.equip()
	assert_eq(equipped.player_stats.snapshot().basic_damage, 22)
	assert_eq(equipped.player_stats.snapshot().giro_damage, 24)
	for run: ArenaRun in [plain, equipped]:
		run.enemies[0].pos = run.player + Vector2(1, 0)
		run.attack_enemy(0)
		run.tick()  # Primeiro sorteio da seed legada acerta.
	assert_eq(plain.enemies[0].health.current(), 20.0)
	assert_eq(equipped.enemies[0].health.current(), 14.0)
	assert_eq(plain.rng.state, equipped.rng.state)
	assert_eq(plain.attack_left, equipped.attack_left)
	var plain_before: float = plain.enemies[0].health.current()
	var equipped_before: float = equipped.enemies[0].health.current()
	# Mesmo alvo com HP suficiente para medir o Giro sem clamp de morte.
	plain.enemies[0].health.heal(36.0)
	equipped.enemies[0].health.heal(36.0)
	plain.cast_whirlwind()
	equipped.cast_whirlwind()
	assert_eq(plain.enemies[0].health.current(), 12.0)
	assert_eq(equipped.enemies[0].health.current(), 12.0)
	assert_eq(plain.mana, equipped.mana)
	assert_eq(plain.skill_left, equipped.skill_left)
	assert_eq(plain.rng.state, equipped.rng.state)
	assert_gt(plain_before, equipped_before)


func test_rule_fields_are_consumed_without_mutating_shared_definitions() -> void:
	var definition: ArenaRules = ArenaRules.new()
	definition.player_damage = 10
	definition.equipment_damage_bonus = 2
	definition.skill_damage_bonus = 3
	var run: ArenaRun = ArenaRun.new(definition)
	run.inventory.append("Ferro funerário")
	run.equip()
	run.equip()
	assert_eq(run.player_stats.snapshot().basic_damage, 12)
	assert_eq(run.player_stats.snapshot().giro_damage, 13)
	assert_eq(definition.player_damage, 10)
	assert_eq(definition.equipment_damage_bonus, 2)
	assert_eq(definition.skill_damage_bonus, 3)


func test_invalid_equipment_source_does_not_partially_equip() -> void:
	var definition: ArenaRules = ArenaRules.new()
	definition.equipment_damage_bonus = -1
	var run: ArenaRun = ArenaRun.new(definition)
	run.inventory.append("Ferro funerário")
	var notice_before: String = run.notice
	run.equip()
	assert_false(run.equipped)
	assert_eq(run.player_stats.snapshot().basic_damage, 16)
	assert_eq(run.notice, notice_before)


func test_restart_creates_clean_stats_and_preserves_old_instance() -> void:
	var main: Node2D = load("res://main.tscn").instantiate() as Node2D
	add_child_autofree(main)
	main._start()
	var old_stats: StatsComponent = main.run.player_stats
	main.run.inventory.append("Ferro funerário")
	main.run.equip()
	assert_eq(old_stats.snapshot().basic_damage, 22)
	var restart: InputEventKey = InputEventKey.new()
	restart.physical_keycode = KEY_R
	restart.pressed = true
	main._unhandled_input(restart)
	assert_ne(main.run.player_stats, old_stats)
	assert_eq(main.run.player_stats.snapshot().basic_damage, 16)
	assert_eq(main.run.player_stats.snapshot().giro_damage, 24)
	assert_false(main.run.equipped)
	assert_eq(old_stats.snapshot().basic_damage, 22)

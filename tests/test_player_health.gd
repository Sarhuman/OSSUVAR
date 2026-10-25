extends GutTest

const RULES: Resource = preload("res://data/arena_rules.tres")


func new_run() -> ArenaRun:
	return ArenaRun.new(RULES as ArenaRules)


func ready_hit(run: ArenaRun, index: int) -> void:
	run.enemies[index].pos = run.player + Vector2(0.7, 0)
	run.enemies[index].windup = 1
	run.enemies[index].cooldown = run.rules.enemy_attack_frames


func test_received_damage_consumes_windup_once() -> void:
	var run: ArenaRun = new_run()
	ready_hit(run, 0)
	ready_hit(run, 1)
	watch_signals(run.player_health)
	watch_signals(run)
	run.tick()
	assert_eq(run.player_health.current(), 106.0)
	assert_signal_emit_count(run.player_health, "changed", 2)
	assert_signal_emit_count(run, "feedback", 2)
	run.tick()
	assert_eq(run.player_health.current(), 106.0)
	assert_signal_emit_count(run.player_health, "changed", 2)
	assert_signal_not_emitted(run.player_health, "died")


func test_lethal_hits_emit_death_and_feedback_once() -> void:
	var run: ArenaRun = new_run()
	run.player_health.damage(run.rules.health - 1.0)
	ready_hit(run, 0)
	ready_hit(run, 1)
	watch_signals(run.player_health)
	watch_signals(run)
	run.tick()
	assert_true(run.player_health.is_dead())
	assert_eq(run.player_health.current(), 0.0)
	assert_signal_emit_count(run.player_health, "died", 1)
	assert_signal_emit_count(run.player_health, "changed", 1)
	assert_signal_emit_count(run, "feedback", 1)
	assert_eq(run.notice, "Você caiu. Pressione R para recomeçar.")
	var rng_before: int = run.rng.state
	run.tick()
	assert_eq(run.rng.state, rng_before)
	assert_signal_emit_count(run, "feedback", 1)


func test_potions_keep_legacy_heal_and_reject_unusable_charges() -> void:
	var run: ArenaRun = new_run()
	run.drink_potion()
	assert_eq(run.potions, 4)
	run.player_health.damage(110.0)
	run.drink_potion()
	assert_eq(run.player_health.current(), 70.0)
	assert_eq(run.potions, 3)
	run.drink_potion()
	assert_eq(run.player_health.current(), 120.0)
	assert_eq(run.potions, 2)
	run.player_health.damage(1.0)
	run.potions = 0
	run.drink_potion()
	assert_eq(run.player_health.current(), 119.0)
	assert_eq(run.potions, 0)
	run.potions = 2
	run.player_health.damage(119.0)
	run.drink_potion()
	assert_eq(run.potions, 2)
	assert_eq(run.player_health.current(), 0.0)


func test_level_up_fills_living_player_without_potion_or_rng_cost() -> void:
	var run: ArenaRun = new_run()
	run.player_health.damage(119.0)
	run.xp = run.rules.xp_per_level - run.rules.xp_per_enemy
	var rng_before: int = run.rng.state
	watch_signals(run.player_health)
	run._hurt(0, 999)
	assert_eq(run.level, 2)
	assert_eq(run.xp, 0)
	assert_eq(run.player_health.current(), 120.0)
	assert_eq(run.potions, 4)
	assert_eq(run.rng.state, rng_before)
	assert_signal_emit_count(run.player_health, "changed", 1)
	assert_eq(run.kills, 1)
	assert_eq(run.drops.size(), 1)


func test_late_reward_and_recalculation_cannot_revive_dead_player() -> void:
	var run: ArenaRun = new_run()
	run.player_health.damage(120.0)
	run.xp = run.rules.xp_per_level - run.rules.xp_per_enemy
	watch_signals(run.player_health)
	# Exercita crédito de impacto já aceito, não um comando novo do jogador.
	run._hurt(0, 999)
	assert_eq(run.level, 2)
	assert_true(run.player_health.is_dead())
	assert_eq(run.player_health.current(), 0.0)
	assert_signal_not_emitted(run.player_health, "changed")
	assert_true(run.player_health.set_maximum(240.0).accepted)
	assert_false(run.player_health.heal(240.0).accepted)
	assert_eq(run.player_health.current(), 0.0)
	assert_signal_not_emitted(run.player_health, "died")


func test_dead_player_cannot_start_actions_or_change_combat_state() -> void:
	var run: ArenaRun = new_run()
	run.inventory.append("Ferro funerário")
	run.drops.append({"pos": run.player, "name": "Ferro funerário", "taken": false})
	run.player_health.damage(120.0)
	var rng_before: int = run.rng.state
	run.attack_enemy(0)
	run.walk_to(Vector2i(5, 5))
	run.cast_whirlwind()
	run.drink_potion()
	run.collect()
	run.equip()
	run.tick()
	assert_eq(run.target, -1)
	assert_true(run.path.is_empty())
	assert_eq(run.player, Vector2(3, 3))
	assert_eq(run.mana, 70.0)
	assert_eq(run.potions, 4)
	assert_eq(run.skill_left, 0)
	assert_false(run.equipped)
	assert_false(run.drops[0].taken)
	assert_eq(run.rng.state, rng_before)


func test_pause_inventory_and_restart_preserve_health_ownership() -> void:
	var main: Node2D = load("res://main.tscn").instantiate() as Node2D
	add_child_autofree(main)
	main._start()
	var old_run: ArenaRun = main.run
	var old_health: HealthComponent = main.run.player_health
	ready_hit(main.run, 0)
	main.run.player_health.damage(50.0)
	main.run.skill_left = 10
	var rng_before: int = main.run.rng.state
	press(main, KEY_ESCAPE)
	main._process(0.2)
	assert_eq(main.run.player_health.current(), 70.0)
	assert_eq(main.run.skill_left, 10)
	assert_eq(main.run.enemies[0].windup, 1)
	assert_eq(main.run.rng.state, rng_before)
	press(main, KEY_ESCAPE)
	press(main, KEY_I)
	main._process(0.2)
	assert_eq(main.run.player_health.current(), 70.0)
	assert_eq(main.run.skill_left, 10)
	press(main, KEY_I)
	main._process(ArenaRun.STEP)
	assert_eq(main.run.player_health.current(), 63.0)
	old_health.damage(120.0)
	press(main, KEY_R)
	assert_ne(main.run, old_run)
	assert_ne(main.run.player_health, old_health)
	assert_true(old_health.is_dead())
	assert_eq(main.run.player_health.current(), 120.0)
	assert_false(main.run.player_health.is_dead())
	assert_eq(main.run.level, 1)
	assert_eq(main.run.kills, 0)
	assert_eq(main.run.potions, 4)
	assert_eq(main.run.skill_left, 0)


func press(main: Node2D, key: Key) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.physical_keycode = key
	event.pressed = true
	main._unhandled_input(event)

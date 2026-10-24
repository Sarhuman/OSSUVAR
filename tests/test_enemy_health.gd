extends GutTest

const RULES: Resource = preload("res://data/arena_rules.tres")


func test_replayed_hit_is_rejected_before_health_even_when_nonlethal() -> void:
	var run: ArenaRun = ArenaRun.new(RULES as ArenaRules)
	var hit: EnemyHit = EnemyHit.new(0, 10.0)
	var hp: HealthComponent = run.enemies[0].health
	watch_signals(hp)
	assert_true(run.apply_enemy_hit(hit).accepted)
	assert_false(run.apply_enemy_hit(hit).accepted)
	assert_eq(hp.current(), 26.0)
	assert_signal_emit_count(hp, "changed", 1)
	assert_eq(run.kills, 0)
	assert_false(run.enemies[0].has("hp"))
	var fatal: EnemyHit = EnemyHit.new(0, 999.0)
	assert_true(run.apply_enemy_hit(fatal).died_now)
	assert_false(run.apply_enemy_hit(fatal).accepted)
	assert_false(run.apply_enemy_hit(EnemyHit.new(0, 999.0)).accepted)
	assert_false(hp.heal(999.0).accepted)
	assert_eq(run.kills, 1)
	assert_eq(run.xp, run.rules.xp_per_enemy)
	assert_eq(run.drops.size(), 1)
	assert_signal_emit_count(hp, "died", 1)


func test_invalid_hit_and_distinct_impacts() -> void:
	var run: ArenaRun = ArenaRun.new(RULES as ArenaRules)
	assert_false(run.apply_enemy_hit(null).accepted)
	assert_false(run.apply_enemy_hit(EnemyHit.new(-1, 10.0)).accepted)
	assert_false(run.apply_enemy_hit(EnemyHit.new(10, 10.0)).accepted)
	for invalid: float in [-1.0, NAN, INF, -INF]:
		assert_false(run.apply_enemy_hit(EnemyHit.new(0, invalid)).accepted)
	assert_eq(run.enemies[0].health.current(), 36.0)
	assert_eq(run.enemies[0].flash, 0)
	assert_true(run.apply_enemy_hit(EnemyHit.new(0, 10.0)).accepted)
	assert_true(run.apply_enemy_hit(EnemyHit.new(0, 10.0)).accepted)
	assert_eq(run.enemies[0].health.current(), 16.0)


func test_click_and_automap_use_enemy_health() -> void:
	if DisplayServer.get_name() == "headless":
		pending("Ponteiro nativo: executar esta regressão também com display gráfico.")
		return
	var main: Node2D = load("res://main.tscn").instantiate() as Node2D
	add_child_autofree(main)
	main._start()
	await get_tree().process_frame
	await get_tree().process_frame
	main.run.enemies[0].pos = main.run.player + Vector2(1, 0)
	var at: Vector2 = (
		main.view.get_global_transform_with_canvas()
		* (IsoMath.project(main.run.enemies[0].pos) + Vector2(0, -18))
	)
	Input.warp_mouse(at)
	await get_tree().process_frame
	var click: InputEventMouseButton = InputEventMouseButton.new()
	click.position = at
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	main._unhandled_input(click)
	assert_eq(main.run.target, 0)
	main.run._hurt(0, 999)
	main.run.target = -1
	main._unhandled_input(click)
	assert_ne(main.run.target, 0)
	watch_signals(main.hud)
	main.hud.map_open = true
	main.hud.queue_redraw()
	await get_tree().process_frame
	await get_tree().process_frame
	assert_signal_emitted(main.hud, "draw")
	assert_true(main.hud.map_open)
	assert_true(main.run.enemies[0].health.is_dead())

extends GutTest

const SCENE: PackedScene = preload("res://world/lateral/lateral.tscn")


func test_one_damage_per_execution_and_new_execution() -> void:
	var rules: LateralRules = LateralRules.new()
	var session: LateralSession = LateralSession.new(rules)
	var attacker: LateralFighter = session.player
	assert_true(attacker.begin_attack())
	assert_null(attacker.try_hit(session.enemy), "Preparação não acerta")
	attacker.advance(rules.player_prepare + 0.001)
	assert_not_null(attacker.try_hit(session.enemy))
	for i: int in 10:
		assert_null(attacker.try_hit(session.enemy))
	assert_eq(session.enemy.health.current(), 32.0)
	attacker.advance(rules.active)
	assert_null(attacker.try_hit(session.enemy), "Recuperação não acerta")
	assert_false(attacker.begin_attack())
	attacker.advance(rules.player_recovery)
	assert_true(attacker.begin_attack())
	attacker.advance(rules.player_prepare + 0.001)
	assert_not_null(attacker.try_hit(session.enemy))
	assert_eq(session.enemy.health.current(), 16.0)


func test_stats_is_the_damage_authority() -> void:
	var session: LateralSession = LateralSession.new(LateralRules.new())
	assert_true(session.player.stats.set_source(&"test", 3))
	session.player.begin_attack()
	session.player.advance(0.17)
	session.player.try_hit(session.enemy)
	assert_eq(session.enemy.health.current(), 29.0)


func test_death_cancels_attack_and_is_emitted_once() -> void:
	var session: LateralSession = LateralSession.new(LateralRules.new())
	watch_signals(session.player.health)
	session.player.begin_attack()
	session.player.advance(0.17)
	assert_true(session.player.health.damage(999.0).died_now)
	assert_false(session.player.health.damage(999.0).accepted)
	assert_eq(session.player.phase(), LateralFighter.Phase.READY)
	assert_false(session.player.begin_attack())
	assert_null(session.player.try_hit(session.enemy))
	assert_eq(session.enemy.health.current(), 48.0)
	assert_false(session.player.health.heal(999.0).accepted)
	assert_signal_emit_count(session.player.health, "died", 1)


func test_scene_death_blocks_input_and_restart_is_independent() -> void:
	var stage: LateralStage = SCENE.instantiate() as LateralStage
	add_child_autofree(stage)
	await wait_physics_frames(20)
	var old: LateralSession = stage.session
	var old_actor: LateralActor = stage.player
	var old_rng: RandomNumberGenerator = old.rng_context.stream("probe", "combat")
	old_rng.randi()
	var state: int = old_rng.state
	old.player.health.damage(999.0)
	assert_false(old_actor.request_jump())
	assert_false(old_actor.request_attack())
	var key: InputEventKey = InputEventKey.new()
	key.physical_keycode = KEY_D
	key.pressed = true
	Input.parse_input_event(key)
	var x: float = old_actor.position.x
	await wait_physics_frames(5)
	key.pressed = false
	Input.parse_input_event(key)
	assert_eq(old_actor.position.x, x)
	stage.restart()
	assert_ne(stage.session, old)
	assert_ne(stage.session.player.health, old.player.health)
	assert_ne(stage.session.player.stats, old.player.stats)
	assert_ne(stage.session.rng_context, old.rng_context)
	assert_ne(stage.session.rng_context.stream("probe", "combat"), old_rng)
	assert_true(old.player.health.is_dead())
	assert_eq(old_rng.state, state)
	assert_eq(stage.session.player.health.current(), 100.0)
	assert_false(stage.completed)


func test_ground_jump_air_attack_and_landing() -> void:
	var stage: LateralStage = SCENE.instantiate() as LateralStage
	add_child_autofree(stage)
	await wait_physics_frames(20)
	assert_true(stage.player.is_on_floor())
	assert_true(stage.player.request_jump())
	assert_false(stage.player.request_attack())
	await wait_physics_frames(5)
	assert_false(stage.player.request_jump(), "Sem pulo duplo")
	assert_lt(stage.player.position.y, 620.0)
	await wait_physics_frames(55)
	assert_true(stage.player.is_on_floor())
	assert_almost_eq(stage.player.position.y, 620.0, 1.0)


func test_dead_target_and_two_targets_have_bounded_execution_ledger() -> void:
	var session: LateralSession = LateralSession.new(LateralRules.new())
	var other: LateralSession = LateralSession.new(LateralRules.new())
	session.player.begin_attack()
	session.player.advance(0.17)
	assert_not_null(session.player.try_hit(session.enemy))
	assert_not_null(session.player.try_hit(other.enemy))
	assert_eq(session.player._hit.size(), 2)
	session.enemy.health.damage(999.0)
	assert_null(session.player.try_hit(session.enemy))
	session.player.advance(1.0)
	assert_eq(session.player._hit.size(), 0)

extends GutTest

const SCENE: PackedScene = preload("res://world/lateral/lateral.tscn")


func test_large_steps_do_not_skip_the_active_window_or_repeat_damage() -> void:
	for delta: float in [1.0 / 60.0, 0.1, 0.3, 0.5, 1.0]:
		var session: LateralSession = LateralSession.new(LateralRules.new())
		session.player.begin_attack()
		for i: int in ceili(1.0 / delta):
			session.player.advance(delta, session.enemy)
		assert_eq(session.enemy.health.current(), 32.0, "delta=%s" % delta)
		assert_eq(session.player.phase(), LateralFighter.Phase.READY)
		assert_eq(session.player._hit.size(), 0)
		assert_null(session.player.advance(1.0, session.enemy))
		assert_eq(session.enemy.health.current(), 32.0)


func test_no_delayed_hit_after_a_blocked_window_or_death() -> void:
	var session: LateralSession = LateralSession.new(LateralRules.new())
	session.player.begin_attack()
	session.player.advance(0.3)  # Sem alvo elegível durante toda a janela.
	assert_null(session.player.advance(0.01, session.enemy))
	assert_eq(session.enemy.health.current(), 48.0)
	session.player.advance(1.0)
	session.player.begin_attack()
	session.player.health.damage(999.0)
	assert_null(session.player.advance(1.0, session.enemy))
	assert_eq(session.enemy.health.current(), 48.0)


func test_removed_and_freed_opponents_are_safe() -> void:
	var stage: LateralStage = SCENE.instantiate() as LateralStage
	add_child_autofree(stage)
	stage.begin()
	var removed: LateralActor = stage.enemy
	stage.remove_child(removed)
	stage.player.opponent = removed
	assert_null(stage.player.reachable_target())
	removed.free()
	assert_null(stage.player.reachable_target())
	stage.player.enemy = true
	stage.player._enemy_direction()
	assert_true(is_instance_valid(stage.player))
	await wait_physics_frames(2)
	assert_eq(stage.player.opponent, stage.boss)


func test_solid_obstacle_blocks_both_attackers_without_spending_the_hit() -> void:
	var stage: LateralStage = SCENE.instantiate() as LateralStage
	add_child_autofree(stage)
	await wait_physics_frames(3)
	stage.player.set_physics_process(false)
	stage.enemy.set_physics_process(false)
	stage.player.position = Vector2(640, 620)
	stage.enemy.position = Vector2(750, 620)
	stage.player.facing = 1
	stage.enemy.facing = -1
	stage.rules.player_reach = 140
	stage.rules.enemy_reach = 140
	stage.player.opponent = stage.enemy
	stage.enemy.opponent = stage.player
	assert_null(stage.player.reachable_target(), "Bloco X=660..730 obstrui")
	assert_null(stage.enemy.reachable_target())
	stage.session.player.begin_attack()
	stage.session.player.advance(0.17, stage.player.reachable_target())
	assert_eq(stage.session.enemy.health.current(), 48.0)
	assert_eq(stage.session.player._hit.size(), 0)
	stage.enemy.position = Vector2(650, 620)
	assert_eq(stage.player.reachable_target(), stage.session.enemy)
	stage.session.player.advance(0.02, stage.player.reachable_target())
	assert_eq(stage.session.enemy.health.current(), 32.0)


func test_menu_boss_gate_ending_and_restart() -> void:
	var stage: LateralStage = SCENE.instantiate() as LateralStage
	add_child_autofree(stage)
	assert_false(stage.active)
	assert_false(stage.player.can_control())
	assert_false(stage.player.request_attack())
	assert_false(stage.player.request_jump())
	stage.begin()
	stage.player.position = Vector2(2280, 620)
	await wait_physics_frames(4)
	assert_false(stage.completed, "Saída exige derrotar o chefe")
	stage.session.boss.health.damage(999.0)
	await wait_physics_frames(3)
	assert_true(stage.completed)
	assert_false(stage.player.can_control())
	var old: LateralSession = stage.session
	stage._primary()
	assert_true(stage.active)
	assert_false(stage.completed)
	assert_true(old.boss.health.is_dead())
	assert_ne(stage.session.boss.health, old.boss.health)
	assert_eq(stage.session.boss.health.current(), 128.0)

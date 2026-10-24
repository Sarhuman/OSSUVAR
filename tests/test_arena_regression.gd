extends GutTest


func capture_trace() -> Array[String]:
	var run: ArenaRun = ArenaRun.new(load("res://data/arena_rules.tres") as ArenaRules)
	var trace: Array[String] = [snapshot(run)]
	run.walk_to(Vector2i(10, 7))
	for i: int in 120:
		run.tick()
	trace.append(snapshot(run))
	run.attack_enemy(0)
	for i: int in 150:
		run.tick()
	trace.append(snapshot(run))
	run.cast_whirlwind()
	run.collect()
	run.equip()
	run.drink_potion()
	trace.append(snapshot(run))
	for i: int in 200:
		run.tick()
	trace.append(snapshot(run))
	return trace


func snapshot(run: ArenaRun) -> String:
	var enemies: Array = []
	for enemy: Dictionary in run.enemies:
		enemies.append([enemy.pos, enemy.health.current(), enemy.cooldown, enemy.windup])
	return JSON.stringify(
		[
			run.player,
			run.health,
			run.mana,
			run.vigor,
			run.level,
			run.xp,
			run.kills,
			run.potions,
			run.attack_left,
			run.skill_left,
			run.equipped,
			run.inventory,
			run.drops,
			enemies,
			str(run.rng.state),
			run.notice
		]
	)


func test_trace_matches_unmodified_dff6ae1() -> void:
	var expected: Array = JSON.parse_string(
		FileAccess.get_file_as_string("res://tests/fixtures/arena_dff6ae1.json")
	)
	assert_eq_deep(capture_trace(), expected)

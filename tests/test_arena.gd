extends GutTest


func new_run() -> ArenaRun:
	return ArenaRun.new(load("res://data/arena_rules.tres") as ArenaRules)


func test_isometric_roundtrip() -> void:
	for cell: Vector2 in [Vector2.ZERO, Vector2(3, 5), Vector2(12.3, 7.4)]:
		assert_almost_eq(IsoMath.unproject(IsoMath.project(cell)).x, cell.x, 0.0001)
		assert_almost_eq(IsoMath.unproject(IsoMath.project(cell)).y, cell.y, 0.0001)


func test_hit_chance_limits_and_zero_denominator() -> void:
	assert_eq(CombatMath.hit_chance(0, 0, 1, 1), 0.05)
	assert_eq(CombatMath.hit_chance(999999, 0, 99, 1), 0.95)
	assert_eq(CombatMath.hit_chance(0, 99999, 1, 99), 0.05)
	assert_almost_eq(CombatMath.hit_chance(100, 100, 1, 1), 0.5, 0.0001)


func test_walk_routes_around_obstacles() -> void:
	var run: ArenaRun = new_run()
	run.walk_to(Vector2i(10, 7))
	for cell: Vector2i in run.path:
		assert_false(run.grid.is_point_solid(cell))
	for i: int in 120:
		run.tick()
	assert_lt(run.player.distance_to(Vector2(10, 7)), 0.05)


func test_wall_click_preserves_current_destination() -> void:
	var run: ArenaRun = new_run()
	run.walk_to(Vector2i(8, 6))
	assert_eq(run.destination, Vector2i(3, 3))
	run.walk_to(Vector2i(-1, -1))
	assert_true(run.path.is_empty())


func test_skill_cost_cooldown_and_out_of_range() -> void:
	var run: ArenaRun = new_run()
	run.cast_whirlwind()
	assert_eq(run.mana, run.rules.mana - run.rules.skill_cost)
	assert_eq(run.enemies[0].hp, run.rules.enemy_health)
	run.cast_whirlwind()
	assert_eq(run.mana, run.rules.mana - run.rules.skill_cost)


func test_skill_rejects_insufficient_mana() -> void:
	var run: ArenaRun = new_run()
	run.mana = 0.0
	run.cast_whirlwind()
	assert_eq(run.skill_left, 0)
	assert_eq(run.mana, 0.0)


func test_kill_rewards_once_and_loot_is_not_duplicated() -> void:
	var run: ArenaRun = new_run()
	run.player = run.enemies[0].pos
	run.enemies[0].hp = 1.0
	run.cast_whirlwind()
	assert_eq(run.kills, 1)
	assert_eq(run.xp, run.rules.xp_per_enemy)
	assert_eq(run.drops.size(), 1)
	run.collect()
	run.collect()
	assert_eq(run.inventory.size(), 1)
	run.equip()
	assert_true(run.equipped)


func test_loot_capacity_preserves_uncollected_drop() -> void:
	var run: ArenaRun = new_run()
	for i: int in run.rules.inventory_capacity:
		run.inventory.append("Ferro funerário")
	run.drops.append({"pos": run.player, "name": "Ferro funerário", "taken": false})
	run.collect()
	assert_false(run.drops[0].taken)
	assert_eq(run.inventory.size(), run.rules.inventory_capacity)


func test_death_freezes_actions() -> void:
	var run: ArenaRun = new_run()
	run.health = 0.0
	run.walk_to(Vector2i(4, 4))
	run.cast_whirlwind()
	run.drink_potion()
	run.tick()
	assert_eq(run.player, Vector2(3, 3))
	assert_eq(run.health, 0.0)
	assert_eq(run.mana, run.rules.mana)
	assert_eq(run.potions, 4)


func test_enemy_telegraph_delays_damage() -> void:
	var run: ArenaRun = new_run()
	run.enemies[0].pos = run.player + Vector2(0.7, 0)
	run.tick()
	assert_eq(run.health, run.rules.health)
	assert_gt(run.enemies[0].windup, 0)
	for i: int in 10:
		run.tick()
	assert_eq(run.health, run.rules.health - run.rules.enemy_damage)


func test_potion_does_not_waste_charge_at_full_health() -> void:
	var run: ArenaRun = new_run()
	run.drink_potion()
	assert_eq(run.potions, 4)
	run.health = 10.0
	run.drink_potion()
	assert_eq(run.potions, 3)
	assert_eq(run.health, 70.0)


func test_fixed_seed_reproduces_basic_combat() -> void:
	var a: ArenaRun = new_run()
	var b: ArenaRun = new_run()
	a.enemies[0].pos = a.player + Vector2(1, 0)
	b.enemies[0].pos = b.player + Vector2(1, 0)
	a.attack_enemy(0)
	b.attack_enemy(0)
	for i: int in 150:
		a.tick()
		b.tick()
	assert_eq(a.health, b.health)
	assert_eq(a.kills, b.kills)
	assert_eq(a.enemies[0].hp, b.enemies[0].hp)


func test_clear_arena_levels_up_and_does_not_reward_dead_enemies_again() -> void:
	var run: ArenaRun = new_run()
	for i: int in run.enemies.size():
		run.player = run.enemies[i].pos
		run.enemies[i].hp = 1.0
		run.mana = run.rules.mana
		run.skill_left = 0
		run.cast_whirlwind()
	assert_eq(run.kills, 10)
	assert_eq(run.level, 4)
	assert_eq(run.xp, 25)
	assert_eq(run.drops.size(), 10)
	assert_true(run.notice.contains("Arena concluída"))
	var old_xp: int = run.xp
	run.skill_left = 0
	run.cast_whirlwind()
	assert_eq(run.xp, old_xp)


func test_potion_empty_and_mana_regeneration_cap() -> void:
	var run: ArenaRun = new_run()
	run.potions = 0
	run.health = 1.0
	run.drink_potion()
	assert_eq(run.health, 1.0)
	run.tick()
	assert_eq(run.mana, run.rules.mana)

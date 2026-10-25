extends GutTest

const MAX_SEED: int = 9223372036854775807


func test_fixed_vectors_from_python_hashlib() -> void:
	var vectors: Array = JSON.parse_string(
		FileAccess.get_file_as_string("res://tests/fixtures/rng_t3_vectors.json")
	)
	for row: Array in vectors:
		assert_eq(
			RngSeed.derive(
				String(row[0]).to_int(),
				row[1],
				String(row[2]).to_int(),
				String(row[3]).to_int(),
				row[4]
			),
			String(row[5]).to_int()
		)


func test_invalid_parameters_are_rejected_without_resetting_stream() -> void:
	for invalid: Variant in [-1, 1.5, NAN, INF, true, "1314", null]:
		assert_null(Rng.create_context("run", invalid))
		assert_eq(RngSeed.derive(invalid, "arena", 1, 1, "combat"), -1)
	for invalid: Variant in [0, -1, 1.5, NAN, INF, true, "1", null]:
		assert_null(Rng.create_context("run", 1314, invalid, 1))
		assert_null(Rng.create_context("run", 1314, 1, invalid))
		assert_eq(RngSeed.derive(1314, "arena", invalid, 1, "combat"), -1)
	var context: RngContext = Rng.create_context("run", 1314)
	var combat: RandomNumberGenerator = context.stream("arena", "combat")
	combat.randi()
	var before: int = combat.state
	for invalid: Variant in ["", "não_ascii", "two words", "\n", "a".repeat(129), 1, null]:
		assert_null(context.stream(invalid, "combat"))
		assert_null(Rng.create_context(invalid, 1314))
		assert_eq(RngSeed.derive(1314, invalid, 1, 1, "combat"), -1)
	for invalid: Variant in ["", "cosmetic", "Combat", 1, null]:
		assert_null(context.stream("arena", invalid))
		assert_eq(RngSeed.derive(1314, "arena", 1, 1, invalid), -1)
	assert_null(Rng.create_context("run", 1314, 1, 1, "unknown"))
	assert_eq(combat.state, before)
	assert_eq(context.stream("arena", "combat"), combat)


func test_lookup_retains_sequence_and_contexts_do_not_interfere() -> void:
	var a: RngContext = Rng.create_context("run:a", 1314)
	var b: RngContext = Rng.create_context("run:b", 1314)
	var combat: RandomNumberGenerator = a.stream("zone:a", "combat")
	assert_ne(combat, b.stream("zone:a", "combat"))
	for i: int in 20:
		assert_eq(combat.randi(), b.stream("zone:a", "combat").randi())
		assert_eq(a.stream("zone:a", "combat"), combat)
	var before: int = combat.state
	for i: int in 100:
		a.stream("zone:a", "loot").randi()
		a.stream("zone:a", "world").randi()
	assert_eq(combat.state, before)
	assert_eq(combat.randi(), b.stream("zone:a", "combat").randi())
	assert_ne(a.stream("zone:b", "combat"), combat)
	assert_ne(a.stream("zone:b", "combat").seed, combat.seed)
	assert_ne(a.stream("zone:a", "loot").seed, combat.seed)


func test_versions_and_run_id_contract() -> void:
	var a: RngContext = Rng.create_context("a", 0, 1, 1)
	var b: RngContext = Rng.create_context("b", 0, 1, 1)
	assert_ne(a.run_id(), b.run_id())
	assert_eq(a.stream("arena", "combat").randi(), b.stream("arena", "combat").randi())
	var next_generation: RngContext = Rng.create_context("a", 0, 2, 1)
	var next_version: RngContext = Rng.create_context("a", 0, 1, 2)
	assert_ne(a.stream("arena", "combat").seed, next_generation.stream("arena", "combat").seed)
	assert_ne(a.stream("arena", "combat").seed, next_version.stream("arena", "combat").seed)


func test_legacy_profile_preserves_custom_and_extreme_seeds() -> void:
	for seed_value: int in [0, 1314, 987654, MAX_SEED]:
		var context: RngContext = Rng.create_context("legacy", seed_value, 1, 1, &"arena_legacy_v1")
		var control: RandomNumberGenerator = RandomNumberGenerator.new()
		control.seed = seed_value
		var definition: ArenaRules = ArenaRules.new()
		definition.seed_value = seed_value
		var run: ArenaRun = ArenaRun.new(definition)
		var combat: RandomNumberGenerator = context.stream("arena", "combat")
		assert_eq(run.rng.seed, seed_value)
		assert_eq(run.rng.state, control.state)
		assert_eq(combat.seed, seed_value)
		assert_eq(combat.state, control.state)
		for i: int in 10:
			var expected: int = control.randi()
			assert_eq(combat.randi(), expected)
			assert_eq(run.rng.randi(), expected)
		assert_eq(
			context.stream("arena", "loot").seed, RngSeed.derive(seed_value, "arena", 1, 1, "loot")
		)
		assert_eq(
			context.stream("arena", "world").seed,
			RngSeed.derive(seed_value, "arena", 1, 1, "world")
		)


func test_service_does_not_retain_contexts() -> void:
	var context: RngContext = Rng.create_context("temporary", 1314)
	var reference: WeakRef = weakref(context)
	context.stream("arena", "combat").randi()
	context = null
	assert_null(reference.get_ref())


func test_simultaneous_arena_runs_and_loot_interleaving() -> void:
	var rules: ArenaRules = load("res://data/arena_rules.tres") as ArenaRules
	var a: ArenaRun = ArenaRun.new(rules)
	var b: ArenaRun = ArenaRun.new(rules)
	assert_ne(a.rng_context, b.rng_context)
	assert_ne(a.rng_context.run_id(), b.rng_context.run_id())
	assert_eq(a.rng, a.rng_context.stream("arena", "combat"))
	assert_ne(a.rng, b.rng)
	for run: ArenaRun in [a, b]:
		run.enemies[0].pos = run.player + Vector2(1, 0)
		run.attack_enemy(0)
	for i: int in 100:
		a.rng_context.stream("arena", "loot").randi()
		a.tick()
		b.tick()
	assert_eq(a.rng.state, b.rng.state)
	assert_eq(a.player_health.current(), b.player_health.current())
	assert_eq(a.enemies[0].health.current(), b.enemies[0].health.current())
	assert_eq(a.xp, b.xp)
	assert_eq(a.drops.size(), b.drops.size())


func test_restart_creates_context_without_resetting_previous_run() -> void:
	var main: Node2D = load("res://main.tscn").instantiate() as Node2D
	add_child_autofree(main)
	main._start()
	var previous: ArenaRun = main.run
	previous.rng.randi()
	var before: int = previous.rng.state
	var restart: InputEventKey = InputEventKey.new()
	restart.physical_keycode = KEY_R
	restart.pressed = true
	main._unhandled_input(restart)
	assert_ne(main.run.rng_context, previous.rng_context)
	assert_ne(main.run.rng, previous.rng)
	assert_eq(previous.rng.state, before)
	var control: RandomNumberGenerator = RandomNumberGenerator.new()
	control.seed = previous.rules.seed_value
	assert_eq(main.run.rng.state, control.state)

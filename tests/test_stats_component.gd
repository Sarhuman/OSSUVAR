extends GutTest


func test_sources_replace_remove_and_do_not_affect_giro() -> void:
	var stats: StatsComponent = StatsComponent.new(ArenaRules.new())
	assert_true(stats.is_valid())
	assert_eq(stats.snapshot().basic_damage, 16)
	assert_eq(stats.snapshot().giro_damage, 24)
	assert_true(stats.set_source(&"equipment:test", 6))
	assert_true(stats.set_source(&"equipment:test", 6))
	assert_eq(stats.snapshot().basic_damage, 22)
	assert_true(stats.set_source(&"equipment:test", 3))
	assert_eq(stats.snapshot().basic_damage, 19)
	assert_true(stats.set_source(&"other:test", 2))
	assert_eq(stats.snapshot().basic_damage, 21)
	assert_true(stats.remove_source(&"equipment:test"))
	assert_eq(stats.snapshot().basic_damage, 18)
	assert_true(stats.remove_source(&"other:test"))
	assert_eq(stats.snapshot().basic_damage, 16)
	assert_false(stats.remove_source(&"other:test"))
	assert_eq(stats.snapshot().giro_damage, 24)


func test_snapshot_is_detached_from_canonical_state() -> void:
	var stats: StatsComponent = StatsComponent.new(ArenaRules.new())
	var before: StatsComponent.Snapshot = stats.snapshot()
	assert_true(stats.set_source(&"equipment:test", 6))
	assert_eq(before.basic_damage, 16)
	var received: StatsComponent.Snapshot = stats.snapshot()
	received.basic_damage = -999
	received.giro_damage = -999
	assert_eq(stats.snapshot().basic_damage, 22)
	assert_eq(stats.snapshot().giro_damage, 24)


func test_shared_resource_and_instances_do_not_share_sources() -> void:
	var definition: ArenaRules = ArenaRules.new()
	var a: StatsComponent = StatsComponent.new(definition)
	var b: StatsComponent = StatsComponent.new(definition)
	assert_true(a.set_source(&"equipment:test", 6))
	assert_eq(b.snapshot().basic_damage, 16)
	assert_eq(definition.player_damage, 16)
	assert_eq(definition.equipment_damage_bonus, 6)
	assert_eq(definition.skill_damage_bonus, 8)
	definition.player_damage = 100
	assert_eq(a.snapshot().basic_damage, 22)
	assert_eq(b.snapshot().basic_damage, 16)


func test_invalid_sources_are_atomic_and_do_not_coerce_values() -> void:
	var stats: StatsComponent = StatsComponent.new(ArenaRules.new())
	assert_true(stats.set_source(&"equipment:test", 6))
	for invalid: Variant in [-1, 6.0, NAN, INF, -INF, "6", null, {}, true]:
		assert_false(stats.set_source(&"equipment:test", invalid))
		assert_eq(stats.snapshot().basic_damage, 22)
		assert_eq(stats.snapshot().giro_damage, 24)
	assert_false(stats.set_source(&"", 6))
	assert_false(stats.set_source(&"equipment:test", StatsComponent.MAX_DAMAGE))
	assert_eq(stats.snapshot().basic_damage, 22)
	assert_true(stats.remove_source(&"equipment:test"))
	assert_eq(stats.snapshot().basic_damage, 16)


func test_overflow_rejection_preserves_all_existing_sources() -> void:
	var stats: StatsComponent = StatsComponent.new(ArenaRules.new())
	assert_true(stats.set_source(&"a", StatsComponent.MAX_DAMAGE - 16))
	assert_false(stats.set_source(&"b", 1))
	assert_eq(stats.snapshot().basic_damage, StatsComponent.MAX_DAMAGE)
	assert_true(stats.set_source(&"a", 0))
	assert_eq(stats.snapshot().basic_damage, 16)
	assert_eq(stats.snapshot().giro_damage, 24)


func test_invalid_definitions_are_inert() -> void:
	var definitions: Array[ArenaRules] = [
		null, ArenaRules.new(), ArenaRules.new(), ArenaRules.new()
	]
	definitions[1].player_damage = -1
	definitions[2].skill_damage_bonus = -1
	definitions[3].player_damage = StatsComponent.MAX_DAMAGE
	for definition: ArenaRules in definitions:
		var stats: StatsComponent = StatsComponent.new(definition)
		assert_false(stats.is_valid())
		assert_false(stats.set_source(&"equipment:test", 6))
		assert_eq(stats.snapshot().basic_damage, 0)
		assert_eq(stats.snapshot().giro_damage, 0)

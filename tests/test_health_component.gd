extends GutTest


func test_zero_and_invalid_operations_do_not_mutate() -> void:
	var hp: HealthComponent = HealthComponent.new(36.0)
	watch_signals(hp)
	var zero: HealthComponent.Result = hp.damage(0.0)
	assert_true(zero.accepted)
	assert_eq(zero.damage_applied, 0.0)
	for invalid: float in [-1.0, NAN, INF, -INF]:
		assert_false(hp.damage(invalid).accepted)
		assert_false(hp.heal(invalid).accepted)
		assert_false(hp.set_maximum(invalid).accepted)
	assert_false(hp.set_maximum(0.0).accepted)
	assert_eq(hp.current(), 36.0)
	assert_eq(hp.maximum(), 36.0)
	assert_signal_not_emitted(hp, "changed")
	assert_signal_not_emitted(hp, "died")


func test_damage_heal_and_maximum_keep_absolute_hp() -> void:
	var hp: HealthComponent = HealthComponent.new(36.0)
	var hit: HealthComponent.Result = hp.damage(10.0)
	assert_true(hit.accepted)
	assert_eq(hit.before, 36.0)
	assert_eq(hit.after, 26.0)
	assert_eq(hit.damage_applied, 10.0)
	assert_false(hit.died_now)
	assert_true(hp.heal(0.0).accepted)
	assert_true(hp.heal(5.0).accepted)
	assert_eq(hp.current(), 31.0)
	assert_true(hp.set_maximum(50.0).accepted)
	assert_eq(hp.current(), 31.0)
	assert_true(hp.set_maximum(20.0).accepted)
	assert_eq(hp.current(), 20.0)
	hp.damage(5.0)
	hp.heal(1.0e308)
	assert_eq(hp.current(), 20.0)


func test_death_is_once_and_cannot_be_reversed() -> void:
	var hp: HealthComponent = HealthComponent.new(36.0)
	watch_signals(hp)
	var fatal: HealthComponent.Result = hp.damage(1.0e308)
	assert_eq(fatal.damage_applied, 36.0)
	assert_true(fatal.died_now)
	assert_true(hp.is_dead())
	assert_signal_emit_count(hp, "died", 1)
	assert_signal_emit_count(hp, "changed", 1)
	assert_false(hp.damage(1.0).accepted)
	assert_false(hp.heal(36.0).accepted)
	assert_true(hp.set_maximum(72.0).accepted)
	assert_eq(hp.current(), 0.0)
	assert_signal_emit_count(hp, "died", 1)


func test_finite_extremes_and_invalid_initialization() -> void:
	var hp: HealthComponent = HealthComponent.new(1.0e308)
	hp.damage(5.0e307)
	hp.heal(1.0e308)
	assert_eq(hp.current(), hp.maximum())
	assert_true(is_finite(hp.current()))
	assert_true(hp.set_maximum(0.001).accepted)
	assert_eq(hp.current(), 0.001)
	var exact: HealthComponent = HealthComponent.new(36.0)
	assert_true(exact.damage(36.0).died_now)
	assert_eq(exact.current(), 0.0)
	for invalid: float in [0.0, -1.0, NAN, INF, -INF]:
		var inert: HealthComponent = HealthComponent.new(invalid)
		assert_true(inert.is_dead())
		assert_eq(inert.maximum(), 1.0)
		assert_false(inert.heal(1.0).accepted)

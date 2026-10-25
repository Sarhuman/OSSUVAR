class_name LateralFighter
extends RefCounted
## Ataque local: ledger limitado à execução, fora da autoridade de Health.

enum Phase { READY, PREPARE, ACTIVE, RECOVER }

var health: HealthComponent
var stats: StatsComponent
var age: float = -1.0
var prepare: float
var active: float
var recovery: float
var _hit: Dictionary[int, bool] = {}


func _init(hp: float, definition: ArenaRules, windup: float, hit_time: float, rest: float) -> void:
	health = HealthComponent.new(hp)
	stats = StatsComponent.new(definition)
	prepare = windup
	active = hit_time
	recovery = rest
	health.died.connect(cancel)


func phase() -> Phase:
	if age < 0.0:
		return Phase.READY
	if age < prepare:
		return Phase.PREPARE
	if age < prepare + active:
		return Phase.ACTIVE
	return Phase.RECOVER


func begin_attack() -> bool:
	if health.is_dead() or phase() != Phase.READY:
		return false
	_hit.clear()
	age = 0.0
	return true


func advance(delta: float, target: LateralFighter = null) -> HealthComponent.Result:
	if age < 0.0 or not is_finite(delta) or delta < 0.0:
		return null
	var next_age: float = age + delta
	var result: HealthComponent.Result = null
	# Resolver a interseção temporal antes de descartar a execução/ledger.
	# O adapter fornece somente um alvo cuja geometria está livre neste passo.
	if target != null and age < prepare + active and next_age >= prepare:
		age = maxf(age, prepare)
		result = try_hit(target)
	age = next_age
	if age >= prepare + active + recovery:
		cancel()
	return result


func cancel() -> void:
	age = -1.0
	_hit.clear()


func try_hit(target: LateralFighter) -> HealthComponent.Result:
	if health.is_dead() or phase() != Phase.ACTIVE or target == null:
		return null
	var id: int = target.get_instance_id()
	if target.health.is_dead() or _hit.has(id):
		return null
	var result: HealthComponent.Result = target.health.damage(stats.snapshot().basic_damage)
	if result.accepted:
		_hit[id] = true
	return result

class_name HealthComponent
extends RefCounted
## Vida exclusiva; máximo finito > 0, operações finitas >= 0. Sem ressurreição.

signal changed
signal died


class Result:
	extends RefCounted
	var accepted: bool = false
	var damage_applied: float = 0.0
	var before: float = 0.0
	var after: float = 0.0
	var maximum_before: float = 0.0
	var maximum_after: float = 0.0
	var died_now: bool = false


var _current: float = 0.0
var _maximum: float = 1.0


func _init(initial_maximum: float = 1.0) -> void:
	# Configuração inválida nasce inerte; nenhum valor não finito é armazenado.
	if is_finite(initial_maximum) and initial_maximum > 0.0:
		_maximum = initial_maximum
		_current = initial_maximum


func current() -> float:
	return _current


func maximum() -> float:
	return _maximum


func is_dead() -> bool:
	return _current == 0.0


func damage(amount: float) -> Result:
	var result: Result = _snapshot()
	if not _valid_amount(amount) or is_dead():
		return result
	result.damage_applied = minf(amount, _current)
	_current -= result.damage_applied
	return _complete(result)


func heal(amount: float) -> Result:
	var result: Result = _snapshot()
	if not _valid_amount(amount) or is_dead():
		return result
	# Limitar antes de somar evita overflow mesmo com quantias finitas enormes.
	_current += minf(amount, _maximum - _current)
	return _complete(result)


func set_maximum(value: float) -> Result:
	var result: Result = _snapshot()
	if not is_finite(value) or value <= 0.0:
		return result
	_maximum = value
	_current = minf(_current, _maximum)
	return _complete(result)


func _valid_amount(value: float) -> bool:
	return is_finite(value) and value >= 0.0


func _snapshot() -> Result:
	var result: Result = Result.new()
	result.before = _current
	result.after = _current
	result.maximum_before = _maximum
	result.maximum_after = _maximum
	return result


func _complete(result: Result) -> Result:
	result.accepted = true
	result.after = _current
	result.maximum_after = _maximum
	result.died_now = result.before > 0.0 and is_dead()
	if result.before != _current or result.maximum_before != _maximum:
		changed.emit()
	if result.died_now:
		died.emit()
	return result

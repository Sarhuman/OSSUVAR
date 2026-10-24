class_name EnemyHit
extends RefCounted
## Token de um impacto em um alvo; ArenaRun consome uma vez, sem ledger global.

var target_index: int
var damage: float
var _consumed: bool = false


func _init(index: int, amount: float) -> void:
	target_index = index
	damage = amount


func consume() -> bool:
	if _consumed:
		return false
	_consumed = true
	return true

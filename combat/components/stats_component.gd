class_name StatsComponent
extends RefCounted
## Recorte legado: base + fontes planas no básico; Giro ignora equipamento.

const MAX_DAMAGE: int = 9223372036854775807


class Snapshot:
	extends RefCounted
	var basic_damage: int = 0
	var giro_damage: int = 0


var _base: ArenaRules
var _sources: Dictionary[StringName, int] = {}


func _init(definition: ArenaRules) -> void:
	if definition == null or definition.player_damage < 0 or definition.skill_damage_bonus < 0:
		return
	if definition.skill_damage_bonus > MAX_DAMAGE - definition.player_damage:
		return
	# Cópia privada das definições; o Resource compartilhado nunca recebe fontes.
	_base = definition.duplicate() as ArenaRules


func is_valid() -> bool:
	return _base != null


func set_source(source_id: StringName, bonus: Variant) -> bool:
	# Variant só nesta fronteira: rejeitar float/NaN/Inf/string sem coerção implícita.
	if not is_valid() or source_id == &"" or typeof(bonus) != TYPE_INT:
		return false
	var value: int = bonus
	if value < 0:
		return false
	var total: int = _base.player_damage
	for key: StringName in _sources:
		if key != source_id:
			total += _sources[key]
	if value > MAX_DAMAGE - total:
		return false
	_sources[source_id] = value
	return true


func remove_source(source_id: StringName) -> bool:
	return _sources.erase(source_id)


func snapshot() -> Snapshot:
	# Sem cache derivado ou referências de retorno para _base/_sources.
	var result: Snapshot = Snapshot.new()
	if not is_valid():
		return result
	result.basic_damage = _base.player_damage
	for value: int in _sources.values():
		result.basic_damage += value
	result.giro_damage = _base.player_damage + _base.skill_damage_bonus
	return result

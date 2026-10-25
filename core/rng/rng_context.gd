class_name RngContext
extends RefCounted
## Dono dos streams desta partida. Sem referências ao serviço ou a outras runs.

var _run_id: String
var _seed_value: int
var _generation: int
var _version: int
var _legacy: bool
var _streams: Dictionary[String, RandomNumberGenerator] = {}


func _init(id: String, seed_value: int, generation: int, version: int, legacy: bool) -> void:
	_run_id = id
	_seed_value = seed_value
	_generation = generation
	_version = version
	_legacy = legacy


func run_id() -> String:
	return _run_id


func stream(zone: Variant, name: Variant) -> RandomNumberGenerator:
	if not RngSeed.valid_id(zone) or not RngSeed.valid_stream(name):
		return null
	var key: String = "%d:%s,%s" % [String(zone).length(), zone, name]
	if _streams.has(key):
		return _streams[key]
	var seed_value: int = RngSeed.derive(_seed_value, zone, _generation, _version, name)
	if seed_value < 0:
		return null
	if _legacy and String(name) == "combat":
		seed_value = _seed_value
	var generator: RandomNumberGenerator = RandomNumberGenerator.new()
	generator.seed = seed_value
	_streams[key] = generator
	return generator

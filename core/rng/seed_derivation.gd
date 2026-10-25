class_name RngSeed
extends RefCounted
## T3: netstrings UTF-8, SHA-256 e 63 bits não negativos; -1 rejeita entrada.


static func valid_configuration(seed_value: Variant, generation: Variant, version: Variant) -> bool:
	return (
		typeof(seed_value) == TYPE_INT
		and seed_value >= 0
		and typeof(generation) == TYPE_INT
		and generation > 0
		and typeof(version) == TYPE_INT
		and version > 0
	)


static func valid_id(value: Variant) -> bool:
	if typeof(value) != TYPE_STRING and typeof(value) != TYPE_STRING_NAME:
		return false
	var bytes: PackedByteArray = String(value).to_utf8_buffer()
	if bytes.is_empty() or bytes.size() > 128:
		return false
	for byte: int in bytes:
		if byte < 33 or byte > 126:
			return false
	return true


static func valid_stream(value: Variant) -> bool:
	return (
		(typeof(value) == TYPE_STRING or typeof(value) == TYPE_STRING_NAME)
		and String(value) in ["world", "combat", "loot"]
	)


static func derive(
	seed_value: Variant, zone: Variant, generation: Variant, version: Variant, stream: Variant
) -> int:
	if not valid_configuration(seed_value, generation, version):
		return -1
	if not valid_id(zone) or not valid_stream(stream):
		return -1
	var payload: PackedByteArray = []
	for field: Variant in [seed_value, zone, generation, version, stream]:
		var bytes: PackedByteArray = str(field).to_utf8_buffer()
		payload.append_array(("%d:" % bytes.size()).to_utf8_buffer())
		payload.append_array(bytes)
		payload.append(44)  # vírgula do netstring
	var hashing: HashingContext = HashingContext.new()
	if hashing.start(HashingContext.HASH_SHA256) != OK or hashing.update(payload) != OK:
		return -1
	var digest: PackedByteArray = hashing.finish()
	# Retirar o bit de sinal ANTES de montar o inteiro impede overflow assinado.
	var derived: int = digest[0] & 0x7f
	for i: int in range(1, 8):
		derived = (derived << 8) | digest[i]
	return derived

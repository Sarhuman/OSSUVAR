class_name RngService
extends Node
## Fábrica sem registro global: cada chamador possui/libera seu RngContext.


func create_context(
	run_id: Variant,
	seed_value: Variant,
	generation: Variant = 1,
	version: Variant = 1,
	profile: Variant = &"versioned_v1"
) -> RngContext:
	if (
		not RngSeed.valid_id(run_id)
		or not RngSeed.valid_configuration(seed_value, generation, version)
	):
		return null
	if typeof(profile) != TYPE_STRING and typeof(profile) != TYPE_STRING_NAME:
		return null
	if String(profile) not in ["versioned_v1", "arena_legacy_v1"]:
		return null
	return RngContext.new(
		String(run_id), seed_value, generation, version, String(profile) == "arena_legacy_v1"
	)

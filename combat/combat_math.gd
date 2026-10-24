class_name CombatMath
extends RefCounted


static func hit_chance(ar: float, defense: float, attacker_level: int, target_level: int) -> float:
	if ar + defense <= 0.0 or attacker_level + target_level <= 0:
		return 0.05
	return clampf(
		(
			2.0
			* maxf(ar, 0.0)
			/ (ar + defense)
			* float(attacker_level)
			/ float(attacker_level + target_level)
		),
		0.05,
		0.95
	)

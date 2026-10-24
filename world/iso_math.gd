class_name IsoMath
extends RefCounted
## Único contrato de conversão entre grade lógica e projeção 2:1.


static func project(cell: Vector2) -> Vector2:
	return Vector2((cell.x - cell.y) * 32.0, (cell.x + cell.y) * 16.0)


static func unproject(point: Vector2) -> Vector2:
	return Vector2(point.x / 64.0 + point.y / 32.0, point.y / 32.0 - point.x / 64.0)

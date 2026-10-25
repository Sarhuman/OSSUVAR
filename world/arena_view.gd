class_name ArenaView
extends Node2D
## Apresentação da arena; o estado pertence exclusivamente a ArenaRun.

var run: ArenaRun
var camera: Camera2D
var floor_layer: TileMapLayer
var particles: Array[Dictionary] = []
var font: Font = ThemeDB.fallback_font


func setup(model: ArenaRun) -> void:
	run = model
	run.feedback.connect(_feedback)
	camera = Camera2D.new()
	camera.position = IsoMath.project(run.player)
	camera.zoom = Vector2(1.35, 1.35)
	add_child(camera)
	_build_floor()


func _build_floor() -> void:
	var atlas: TileSetAtlasSource = TileSetAtlasSource.new()
	atlas.texture = load("res://world/stone_tiles.svg") as Texture2D
	atlas.texture_region_size = Vector2i(64, 32)
	for i: int in 4:
		atlas.create_tile(Vector2i(i, 0))
	var tiles: TileSet = TileSet.new()
	tiles.tile_size = Vector2i(64, 32)
	tiles.tile_shape = TileSet.TILE_SHAPE_ISOMETRIC
	tiles.tile_layout = TileSet.TILE_LAYOUT_DIAMOND_DOWN
	var source: int = tiles.add_source(atlas)
	floor_layer = TileMapLayer.new()
	floor_layer.tile_set = tiles
	floor_layer.position = Vector2(-32.0, -16.0)
	floor_layer.z_index = -2
	add_child(floor_layer)
	for x: int in run.rules.size:
		for y: int in run.rules.size:
			floor_layer.set_cell(Vector2i(x, y), source, Vector2i((x * 7 + y * 3) % 4, 0))


func _process(delta: float) -> void:
	if run == null:
		return
	camera.position = camera.position.lerp(
		IsoMath.project(run.player) + Vector2(0, -35), 1.0 - exp(-delta * 6.0)
	)
	for p: Dictionary in particles:
		p.life -= delta
	particles = particles.filter(func(p: Dictionary) -> bool: return p.life > 0.0)
	queue_redraw()


func _draw() -> void:
	if run == null:
		return
	var actors: Array[Dictionary] = []
	for cell: Vector2i in run.walls:
		actors.append({"pos": Vector2(cell), "type": "wall"})
	for enemy: Dictionary in run.enemies:
		if enemy.health.is_dead():
			_bones(IsoMath.project(enemy.pos))
		else:
			actors.append({"pos": enemy.pos, "type": "enemy", "data": enemy})
	for drop: Dictionary in run.drops:
		if not drop.taken:
			var at: Vector2 = IsoMath.project(drop.pos)
			draw_circle(at, 9.0, Color(0.7, 0.5, 0.2, 0.14))
			draw_line(at + Vector2(-4, 2), at + Vector2(4, -4), Color("c7a76a"), 3.0)
			draw_line(at + Vector2(-3, -2), at + Vector2(3, 1), Color("e7d4a2"), 1.0)
	actors.append({"pos": run.player, "type": "player"})
	actors.sort_custom(
		func(a: Dictionary, b: Dictionary) -> bool: return a.pos.x + a.pos.y < b.pos.x + b.pos.y
	)
	for actor: Dictionary in actors:
		var at: Vector2 = IsoMath.project(actor.pos)
		match actor.type:
			"wall":
				_pillar(at, actor.pos)
			"player":
				_penitent(at)
			"enemy":
				_skeleton(at, actor.data)
	if not run.path.is_empty():
		var at: Vector2 = IsoMath.project(Vector2(run.destination))
		draw_arc(at, 9.0, 0.0, TAU, 20, Color(0.75, 0.66, 0.43, 0.65), 1.0)
	for p: Dictionary in particles:
		var color: Color = Color("e8d6ae")
		if p.kind == "hurt":
			color = Color("dc7064")
		if p.kind == "loot":
			color = Color("e4bd6a")
		color.a = minf(1.0, float(p.life) * 2.0)
		draw_string(
			font,
			p.at + Vector2(-15, -35 - (1.2 - p.life) * 22),
			p.message,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			13,
			color
		)


func _pillar(at: Vector2, cell: Vector2) -> void:
	var height: float = 24.0 if int(cell.x + cell.y) % 3 == 0 else 16.0
	draw_colored_polygon(
		PackedVector2Array(
			[at + Vector2(-25, 0), at + Vector2(0, 12), at + Vector2(25, 0), at + Vector2(0, -12)]
		),
		Color("292c2a")
	)
	draw_colored_polygon(
		PackedVector2Array(
			[
				at + Vector2(-22, 0),
				at + Vector2(0, 10),
				at + Vector2(0, 10 - height),
				at + Vector2(-22, -height)
			]
		),
		Color("414640")
	)
	draw_colored_polygon(
		PackedVector2Array(
			[
				at + Vector2(0, 10),
				at + Vector2(22, 0),
				at + Vector2(22, -height),
				at + Vector2(0, 10 - height)
			]
		),
		Color("323831")
	)
	draw_colored_polygon(
		PackedVector2Array(
			[
				at + Vector2(-22, -height),
				at + Vector2(0, -height - 10),
				at + Vector2(22, -height),
				at + Vector2(0, 10 - height)
			]
		),
		Color("55594e")
	)
	if int(cell.x + cell.y) % 7 == 0:
		var flame: Vector2 = at + Vector2(0, -height - 8)
		draw_circle(flame, 18, Color(0.8, 0.4, 0.1, 0.08))
		draw_circle(flame, 4, Color("c78040"))
		draw_circle(flame + Vector2(0, -1), 2, Color("ead5a0"))


func _penitent(at: Vector2) -> void:
	draw_set_transform(at)
	draw_circle(Vector2.ZERO, 12, Color(0, 0, 0, 0.4))
	draw_arc(Vector2.ZERO, 14, 0, TAU, 24, Color("bca775"), 1.1)
	var cloak: Color = Color("4d6058") if not run.player_health.is_dead() else Color("383632")
	draw_colored_polygon(
		PackedVector2Array(
			[Vector2(-6, -27), Vector2(5, -28), Vector2(11, -4), Vector2(0, -1), Vector2(-10, -5)]
		),
		cloak
	)
	draw_line(Vector2(-3, -22), Vector2(-5, -5), Color("829080"), 2)
	draw_circle(Vector2(0, -31), 5, Color("b7b49c"))
	draw_arc(Vector2(0, -31), 6, PI, TAU, 12, Color("303e39"), 4)
	draw_line(Vector2(9, -3), Vector2(15, -35), Color("a39375"), 2)
	draw_colored_polygon(
		PackedVector2Array(
			[Vector2(12, -32), Vector2(12, -42), Vector2(20, -40), Vector2(18, -31)]
		),
		Color("8e9690")
	)
	draw_circle(Vector2(-10, -15), 6, Color("555951"))
	draw_arc(Vector2(-10, -15), 6, 0, TAU, 16, Color("a89b7b"), 1)
	if run.attack_flash > 0:
		draw_arc(Vector2(2, -14), 27, -1.7, 1.1, 16, Color("e8d8b1"), 3)
	if run.skill_flash > 0:
		draw_arc(
			Vector2(0, -8),
			run.rules.skill_radius * 25.0,
			-2.8,
			2.7,
			40,
			Color(0.75, 0.82, 0.7, float(run.skill_flash) / 12.0),
			3
		)
	draw_set_transform(Vector2.ZERO)


func _skeleton(at: Vector2, enemy: Dictionary) -> void:
	draw_set_transform(at)
	draw_circle(Vector2.ZERO, 10, Color(0, 0, 0, 0.35))
	var bone: Color = Color("e5dec4") if enemy.flash > 0 else Color("a5a38b")
	if enemy.windup > 0:
		draw_arc(Vector2.ZERO, 17, 0, TAU, 24, Color("ce7b4f"), 2)
	draw_line(Vector2(0, -24), Vector2(0, -9), bone, 3)
	for y: int in 3:
		draw_line(Vector2(-5, -22 + y * 4), Vector2(5, -22 + y * 4), bone, 2)
	draw_line(Vector2(0, -10), Vector2(-6, 0), bone, 2)
	draw_line(Vector2(0, -10), Vector2(5, 0), bone, 2)
	draw_line(Vector2(-4, -22), Vector2(-10, -11), bone, 2)
	draw_line(Vector2(4, -22), Vector2(11, -15), bone, 2)
	draw_line(Vector2(10, -7), Vector2(15, -29), Color("7f8179"), 2)
	draw_circle(Vector2(0, -29), 5, bone)
	draw_circle(Vector2(-2, -30), 1.2, Color("383b32"))
	draw_circle(Vector2(2, -30), 1.2, Color("383b32"))
	if enemy.health.current() < enemy.health.maximum():
		draw_rect(Rect2(-13, -43, 26, 3), Color("282320"))
		draw_rect(
			Rect2(-13, -43, 26 * enemy.health.current() / enemy.health.maximum(), 3),
			Color("a45c47")
		)
	draw_set_transform(Vector2.ZERO)


func _bones(at: Vector2) -> void:
	draw_line(at + Vector2(-6, -2), at + Vector2(7, 1), Color("747967"), 2)
	draw_line(at + Vector2(-3, 4), at + Vector2(3, -4), Color("747967"), 2)
	draw_circle(at + Vector2(5, -3), 3, Color("747967"))


func _feedback(cell: Vector2, message: String, kind: String) -> void:
	particles.append({"at": IsoMath.project(cell), "message": message, "kind": kind, "life": 1.2})

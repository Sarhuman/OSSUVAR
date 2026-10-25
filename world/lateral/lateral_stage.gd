class_name LateralStage
extends Node2D
## Cena própria. Não altera a cena inicial ou os controles da arena.

var rules: LateralRules = LateralRules.new()
var session: LateralSession
var player: LateralActor
var enemy: LateralActor
var camera: Camera2D
var completed: bool = false
var hud: Label
var player_bar: ProgressBar
var enemy_bar: ProgressBar
var surfaces: Array[Rect2] = [
	Rect2(0, 620, 900, 100),
	Rect2(1170, 620, 1230, 100),
	Rect2(320, 520, 160, 18),
	Rect2(940, 545, 150, 18),
	Rect2(1550, 520, 150, 18),
	Rect2(1760, 440, 150, 18),
	Rect2(660, 560, 70, 60)
]


func _ready() -> void:
	for i: int in surfaces.size():
		_solid(surfaces[i], i in [2, 3, 4, 5])
	_solid(Rect2(-24, 0, 24, 720), false)
	_solid(Rect2(2400, 0, 24, 720), false)
	var layer: CanvasLayer = CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(26, 18)
	hud.add_theme_font_size_override("font_size", 21)
	layer.add_child(hud)
	player_bar = _bar(layer, Vector2(26, 160), Color("5bbdb0"))
	enemy_bar = _bar(layer, Vector2(310, 160), Color("dc895f"))
	restart()


func restart() -> void:
	for actor: LateralActor in [player, enemy]:
		if is_instance_valid(actor):
			remove_child(actor)
			actor.queue_free()
	session = LateralSession.new(rules)
	player = _actor(session.player, Vector2(140, 600), false)
	enemy = _actor(session.enemy, Vector2(510, 620), true)
	player.opponent = enemy
	enemy.opponent = player
	camera = Camera2D.new()
	camera.position.y = -180
	camera.limit_left = 0
	camera.limit_right = 2400
	camera.limit_top = 0
	camera.limit_bottom = 720
	player.add_child(camera)
	completed = false


func _actor(fighter: LateralFighter, point: Vector2, hostile: bool) -> LateralActor:
	var actor: LateralActor = LateralActor.new()
	actor.fighter = fighter
	actor.rules = rules
	actor.enemy = hostile
	actor.position = point
	add_child(actor)
	return actor


func _solid(rect: Rect2, one_way: bool) -> void:
	var body: StaticBody2D = StaticBody2D.new()
	var collision: CollisionShape2D = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = rect.size
	collision.shape = shape
	collision.one_way_collision = one_way
	body.position = rect.get_center()
	body.add_child(collision)
	add_child(body)


func _bar(layer: CanvasLayer, point: Vector2, color: Color) -> ProgressBar:
	var bar: ProgressBar = ProgressBar.new()
	bar.position = point
	bar.size = Vector2(250, 14)
	bar.show_percentage = false
	var fill: StyleBoxFlat = StyleBoxFlat.new()
	fill.bg_color = color
	bar.add_theme_stylebox_override("fill", fill)
	layer.add_child(bar)
	return bar


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.physical_keycode:
		KEY_SPACE:
			player.request_jump()
		KEY_J:
			player.request_attack()
		KEY_R:
			restart()


func _process(_delta: float) -> void:
	if not player.fighter.health.is_dead() and player.position.x > 2250 and player.is_on_floor():
		completed = true
		player.controls_enabled = false
	player_bar.max_value = session.player.health.maximum()
	player_bar.value = session.player.health.current()
	enemy_bar.max_value = session.enemy.health.maximum()
	enemy_bar.value = session.enemy.health.current()
	var status: String = "Atravesse as plataformas e alcance a saida."
	if completed:
		status = "SAIDA ALCANCADA — R para uma nova prova."
	elif session.player.health.is_dead():
		status = "VOCE MORREU — R para uma nova prova."
	hud.text = "OSSUVAR  /  LATERAL-00  /  PROVA PROVISORIA\n"
	hud.text += "A/D ou setas: andar   ESPACO: pular   J: atacar no chao   R: reiniciar\n"
	hud.text += status + "\nVida do jogador                     Vida do esqueleto"
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(0, 0, 2400, 720), Color("111b29"))
	for x: int in range(0, 2400, 180):
		draw_rect(Rect2(x + 25, 260, 100, 360), Color("192a39"))
		draw_arc(Vector2(x + 75, 280), 50, PI, TAU, 16, Color("33434d"), 5)
		draw_line(Vector2(x + 75, 235), Vector2(x + 75, 360), Color("2a3b46"), 3)
	for surface: Rect2 in surfaces:
		draw_rect(surface, Color("344451"))
		draw_line(
			surface.position, surface.position + Vector2(surface.size.x, 0), Color("a6b4ac"), 4
		)
		for x: int in range(int(surface.position.x), int(surface.end.x), 42):
			draw_line(
				Vector2(x, surface.position.y + 8), Vector2(x, surface.end.y), Color("273744"), 2
			)
	draw_rect(Rect2(2220, 500, 65, 120), Color("243e40"))
	draw_rect(Rect2(2220, 500, 65, 120), Color("83d3ae"), false, 4)
	draw_string(
		ThemeDB.fallback_font,
		Vector2(2204, 483),
		"SAIDA >",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		24,
		Color("bce3b6")
	)

class_name LateralStage
extends Node2D
## Cena própria. Não altera a cena inicial ou os controles da arena.

var rules: LateralRules = LateralRules.new()
var session: LateralSession
var player: LateralActor
var enemy: LateralActor
var boss: LateralActor
var camera: Camera2D
var completed: bool = false
var active: bool = false
var hud: Label
var player_bar: ProgressBar
var enemy_bar: ProgressBar
var boss_bar: ProgressBar
var panel: PanelContainer
var message: Label
var primary: Button
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
	player_bar = _bar(layer, Vector2(26, 160), Color("5bbdb0"), "Vida do jogador")
	enemy_bar = _bar(layer, Vector2(310, 160), Color("dc895f"), "Esqueleto")
	boss_bar = _bar(layer, Vector2(594, 160), Color("cf6877"), "Sentinela")
	panel = PanelContainer.new()
	panel.position = Vector2(340, 235)
	panel.custom_minimum_size = Vector2(600, 240)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color("172d3b")
	style.set_border_width_all(3)
	style.border_color = Color("5bbdb0")
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 20
	style.content_margin_bottom = 20
	panel.add_theme_stylebox_override("panel", style)
	layer.add_child(panel)
	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 18)
	panel.add_child(column)
	message = Label.new()
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.add_theme_font_size_override("font_size", 23)
	column.add_child(message)
	primary = Button.new()
	primary.custom_minimum_size.y = 48
	primary.pressed.connect(_primary)
	column.add_child(primary)
	restart()


func restart() -> void:
	for actor: LateralActor in _actors():
		if is_instance_valid(actor):
			remove_child(actor)
			actor.queue_free()
	session = LateralSession.new(rules)
	player = _actor(session.player, Vector2(140, 600), false)
	enemy = _actor(session.enemy, Vector2(510, 620), true)
	boss = _actor(session.boss, Vector2(2100, 620), true, true)
	player.opponent = enemy
	enemy.opponent = player
	boss.opponent = player
	camera = Camera2D.new()
	camera.position.y = -180
	camera.limit_left = 0
	camera.limit_right = 2400
	camera.limit_top = 0
	camera.limit_bottom = 720
	player.add_child(camera)
	completed = false
	active = false
	for actor: LateralActor in _actors():
		actor.controls_enabled = false


func _actors() -> Array[LateralActor]:
	var result: Array[LateralActor] = []
	if is_instance_valid(player):
		result.append(player)
	if is_instance_valid(enemy):
		result.append(enemy)
	if is_instance_valid(boss):
		result.append(boss)
	return result


func begin() -> void:
	active = true
	for actor: LateralActor in _actors():
		if is_instance_valid(actor):
			actor.controls_enabled = true


func _primary() -> void:
	if completed or session.player.health.is_dead():
		restart()
	if not active:
		begin()


func _actor(
	fighter: LateralFighter, point: Vector2, hostile: bool, is_boss: bool = false
) -> LateralActor:
	var actor: LateralActor = LateralActor.new()
	actor.fighter = fighter
	actor.rules = rules
	actor.enemy = hostile
	actor.boss = is_boss
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


func _bar(layer: CanvasLayer, point: Vector2, color: Color, caption: String) -> ProgressBar:
	var bar: ProgressBar = ProgressBar.new()
	bar.position = point
	bar.size = Vector2(250, 14)
	bar.show_percentage = false
	var fill: StyleBoxFlat = StyleBoxFlat.new()
	fill.bg_color = color
	bar.add_theme_stylebox_override("fill", fill)
	layer.add_child(bar)
	var title: Label = Label.new()
	title.position.y = -25
	title.text = caption
	title.add_theme_font_size_override("font_size", 17)
	bar.add_child(title)
	return bar


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.physical_keycode:
		KEY_ENTER:
			_primary()
		KEY_SPACE:
			player.request_jump()
		KEY_J:
			player.request_attack()
		KEY_R:
			restart()


func _process(_delta: float) -> void:
	if not is_instance_valid(player) or not player.is_inside_tree():
		return
	player.opponent = null
	for target: LateralActor in _actors():
		if target == player:
			continue
		if (
			is_instance_valid(target)
			and target.is_inside_tree()
			and not target.fighter.health.is_dead()
		):
			if (
				player.opponent == null
				or (
					absf(target.position.x - player.position.x)
					< absf(player.opponent.position.x - player.position.x)
				)
			):
				player.opponent = target
	if (
		active
		and not player.fighter.health.is_dead()
		and session.boss.health.is_dead()
		and player.position.x > 2250
		and player.is_on_floor()
	):
		completed = true
		for actor: LateralActor in _actors():
			if is_instance_valid(actor):
				actor.controls_enabled = false
	player_bar.max_value = session.player.health.maximum()
	player_bar.value = session.player.health.current()
	enemy_bar.max_value = session.enemy.health.maximum()
	enemy_bar.value = session.enemy.health.current()
	boss_bar.max_value = session.boss.health.maximum()
	boss_bar.value = session.boss.health.current()
	var status: String = "Atravesse as plataformas, derrote a sentinela e alcance a saida."
	if player.position.x > 2180 and not session.boss.health.is_dead():
		status = "Saida fechada: derrote a sentinela."
	if completed:
		status = "PERCURSO CONCLUIDO — MVP lateral."
	elif session.player.health.is_dead():
		status = "VOCE MORREU — R para uma nova prova."
	panel.visible = not active or completed or session.player.health.is_dead()
	primary.text = "Jogar novamente / Enter" if active else "Iniciar / Enter"
	message.text = "OSSUVAR\nMVP LATERAL\nAtravesse o percurso e derrote a sentinela."
	if completed:
		message.text = "PERCURSO CONCLUIDO\nA sentinela foi derrotada.\nObrigado por jogar."
	elif session.player.health.is_dead():
		message.text = "VOCE MORREU\nTente novamente.\nUma nova partida cria novos estados."
	hud.text = "OSSUVAR  /  MVP LATERAL  /  ARTE PROVISORIA\n"
	hud.text += "A/D ou setas: andar   ESPACO: pular   J: atacar no chao   R: reiniciar\n"
	hud.text += status
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
	var exit_color: Color = Color("83d3ae")
	if session != null and not session.boss.health.is_dead():
		exit_color = Color("d8a065")
	draw_rect(Rect2(2220, 500, 65, 120), Color("243e40"))
	draw_rect(Rect2(2220, 500, 65, 120), exit_color, false, 4)
	draw_string(
		ThemeDB.fallback_font,
		Vector2(2204, 483),
		"SAIDA >",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		24,
		Color("bce3b6")
	)

extends Node2D
## Composition root do protótipo. Mantém input, simulação e apresentação separados.

var run: ArenaRun
var view: ArenaView
var hud: ArenaHud
var canvas: CanvasLayer
var menu: Control
var accumulator: float = 0.0


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("141b17"))
	_show_menu()
	if "--smoke-arena" in OS.get_cmdline_user_args():
		_start()
		run.walk_to(Vector2i(5, 5))


func _show_menu() -> void:
	canvas = CanvasLayer.new()
	add_child(canvas)
	menu = Control.new()
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(menu)
	var backdrop: TextureRect = TextureRect.new()
	backdrop.texture = load("res://ui/opening.svg") as Texture2D
	if ResourceLoader.exists("res://ui/ossuvar_opening.png"):
		backdrop.texture = load("res://ui/ossuvar_opening.png") as Texture2D
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	menu.add_child(backdrop)
	var shade: ColorRect = ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.02, 0.035, 0.025, 0.35)
	menu.add_child(shade)
	var column: VBoxContainer = VBoxContainer.new()
	column.position = Vector2(70, 165)
	column.size = Vector2(455, 390)
	column.add_theme_constant_override("separation", 20)
	menu.add_child(column)
	_menu_label(column, "O S S U V A R", 44, Color("dfcfa5"))
	_menu_label(column, "O S  T R E Z E  S I N O S", 17, Color("b5aa8a"))
	_menu_label(column, "Um sino tocou onde não devia.\nAgora, ninguém parte.", 18, Color("c9cbbb"))
	var start: Button = Button.new()
	start.text = "ENTRAR NA VIGÍLIA"
	start.custom_minimum_size = Vector2(390, 52)
	start.pressed.connect(_start)
	column.add_child(start)
	_menu_label(
		column,
		(
			"Arena experimental · 2D isométrico\n"
			+ "Clique: mover / atacar · Direito: Giro Ceifador\n"
			+ "1–4: poção · I: inventário · E: recolher"
		),
		13,
		Color("b3b8a5")
	)
	start.grab_focus()


func _menu_label(parent: Node, value: String, font_size: int, color: Color) -> void:
	var label: Label = Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)


func _start() -> void:
	if is_instance_valid(menu):
		menu.queue_free()
	if is_instance_valid(view):
		view.queue_free()
	if is_instance_valid(hud):
		hud.queue_free()
	run = ArenaRun.new(load("res://data/arena_rules.tres") as ArenaRules)
	view = ArenaView.new()
	add_child(view)
	view.setup(run)
	hud = ArenaHud.new()
	hud.run = run
	canvas.add_child(hud)
	accumulator = 0.0


func _process(delta: float) -> void:
	if run == null or hud.paused or hud.inventory_open:
		return
	accumulator += minf(delta, 0.25)
	while accumulator >= ArenaRun.STEP:
		run.tick()
		accumulator -= ArenaRun.STEP


func _unhandled_input(event: InputEvent) -> void:
	if run == null:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_ESCAPE:
				hud.paused = not hud.paused
			KEY_I:
				hud.inventory_open = not hud.inventory_open
			KEY_TAB:
				hud.map_open = not hud.map_open
			KEY_R:
				_start()
			KEY_F:
				if hud.inventory_open:
					run.equip()
	if hud.paused or hud.inventory_open or run.health <= 0.0:
		return
	if (
		event.is_action_pressed("potion_1")
		or event.is_action_pressed("potion_2")
		or event.is_action_pressed("potion_3")
		or event.is_action_pressed("potion_4")
	):
		run.drink_potion()
	if event is InputEventKey and event.pressed and event.physical_keycode == KEY_E:
		run.collect()
	if event is InputEventMouseButton and event.pressed:
		if event.position.y < 78 or event.position.y > get_viewport_rect().size.y - 175:
			return
		if event.button_index == MOUSE_BUTTON_RIGHT:
			run.cast_whirlwind()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			var point: Vector2 = view.get_global_mouse_position()
			for i: int in run.enemies.size():
				var at: Vector2 = IsoMath.project(run.enemies[i].pos) + Vector2(0, -18)
				if run.enemies[i].hp > 0.0 and point.distance_to(at) < 23:
					run.attack_enemy(i)
					return
			run.walk_to(Vector2i(IsoMath.unproject(point).round()))

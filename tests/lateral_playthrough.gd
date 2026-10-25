extends SceneTree
## Input sintético com física real; capturas externas não equivalem a homologação humana.

var stage: Node2D
var ticks: int = 0
var picture: int = 0
var output: String = ""
var frame_times: Array[Dictionary] = []
var held_movement: Dictionary[int, bool] = {}


func _initialize() -> void:
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--evidence="):
			output = argument.trim_prefix("--evidence=")
	if output != "":
		DirAccess.make_dir_recursive_absolute(output)
	run.call_deferred()


func key(code: Key, pressed: bool) -> void:
	if code in [KEY_A, KEY_D]:
		held_movement[code] = pressed
	var event: InputEventKey = InputEventKey.new()
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)


func step(count: int) -> void:
	for i: int in count:
		# Restore synthetic movement after an OS focus change.
		for code: int in held_movement:
			if held_movement[code] and not Input.is_physical_key_pressed(code):
				key(code as Key, true)
		await physics_frame
		await process_frame
		ticks += 1
		if ticks % 6 == 0:
			snapshot("frame_%03d" % picture)
			picture += 1


func snapshot(name: String) -> void:
	if output == "" or DisplayServer.get_name() == "headless":
		return
	RenderingServer.force_draw()
	assert(root.get_texture().get_image().save_png(output.path_join(name + ".png")) == OK)
	if not name.begins_with("frame_"):
		print("VISUAL_STEP: ", name)
	if name.begins_with("frame_"):
		frame_times.append({"file": name + ".png", "physics_frame": Engine.get_physics_frames()})


func tap(code: Key) -> void:
	key(code, true)
	await step(2)
	key(code, false)


func walk_to(x: float) -> void:
	key(KEY_D, true)
	var timeout: int = 0
	while stage.player.position.x < x and not stage.completed and timeout < 500:
		await step(1)
		timeout += 1
	key(KEY_D, false)
	assert(timeout < 500, "Percurso bloqueado em x=%s" % stage.player.position.x)


func land(height: float) -> void:
	for i: int in 90:
		await step(1)
		if stage.player.is_on_floor() and absf(stage.player.position.y - height) < 2:
			return
	assert(false, "Aterrissagem incorreta: %s" % stage.player.position)


func run() -> void:
	create_timer(55).timeout.connect(func() -> void: quit(1))
	stage = (load("res://world/lateral/lateral.tscn") as PackedScene).instantiate() as Node2D
	root.add_child(stage)
	await step(20)
	assert(stage.player.is_on_floor())
	snapshot("01_inicio")
	var before: float = stage.player.position.x
	key(KEY_A, true)
	await step(8)
	key(KEY_A, false)
	assert(stage.player.position.x < before)
	await walk_to(300)
	key(KEY_D, true)
	await tap(KEY_SPACE)
	snapshot("02_salto")
	await walk_to(412)
	await land(520)
	snapshot("03_plataforma")
	await walk_to(510)
	await land(620)
	for attack: int in 3:
		var direction: Key = KEY_D if stage.enemy.position.x > stage.player.position.x else KEY_A
		key(direction, true)
		await step(1)
		key(direction, false)
		await tap(KEY_J)
		await step(12)
		snapshot("04_combate_%d" % attack)
		await step(20)
	assert(stage.session.enemy.health.is_dead(), "Três ataques devem derrotar o esqueleto")
	assert(not stage.session.player.health.is_dead())
	key(KEY_D, true)
	await step(100)
	key(KEY_D, false)
	assert(stage.player.position.x > 640 and stage.player.position.x < 650)
	snapshot("05_obstaculo_solido")
	key(KEY_D, true)
	await tap(KEY_SPACE)
	await walk_to(850)
	await land(620)
	key(KEY_D, true)
	await tap(KEY_SPACE)
	await walk_to(1010)
	await land(545)
	snapshot("06_plataforma_sobre_vao")
	key(KEY_D, true)
	await tap(KEY_SPACE)
	await walk_to(1235)
	await land(620)
	await walk_to(2260)
	await step(3)
	assert(stage.completed)
	assert(stage.camera.get_screen_center_position().x <= 1761.0)
	snapshot("07_saida")
	var old: RefCounted = stage.session
	await tap(KEY_R)
	assert(stage.session != old and not stage.completed)
	assert(stage.session.player.health.current() == 100.0)
	print("LATERAL_PLAYTHROUGH_OK: esquerda/direita, salto, duas plataformas, aterrissagens,")
	print("obstaculo solido, 3 ataques, esqueleto morto, camera limitada, saida e R.")
	print("CAPTURES=", picture, "; input sintetico / fisica real; nao homologacao manual.")
	if output != "":
		var file: FileAccess = FileAccess.open(output.path_join("frames.json"), FileAccess.WRITE)
		file.store_string(JSON.stringify(frame_times, "\t"))
	quit(0)

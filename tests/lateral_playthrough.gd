extends SceneTree
## Input sintético com física real; capturas externas não equivalem a homologação humana.

var stage: Node2D
var ticks: int = 0
var picture: int = 0
var recording: bool = true
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
		if ticks % 6 == 0 and recording:
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


func fight(target: Node2D, strikes: int, label: String) -> void:
	for attack: int in strikes:
		while stage.player.fighter.phase() != 0:
			await step(1)
		if absf(target.position.x - stage.player.position.x) < 30.0:
			var away: Key = KEY_A if target.position.x >= stage.player.position.x else KEY_D
			key(away, true)
			while absf(target.position.x - stage.player.position.x) < 38.0:
				await step(1)
			key(away, false)
		var direction: Key = KEY_D if target.position.x > stage.player.position.x else KEY_A
		key(direction, true)
		var timeout: int = 0
		while absf(target.position.x - stage.player.position.x) > 50.0 and timeout < 120:
			await step(1)
			timeout += 1
		await step(1)
		key(direction, false)
		var before: float = target.fighter.health.current()
		await tap(KEY_J)
		assert(stage.player.fighter.phase() != 0)
		await step(12)
		snapshot("%s_%d" % [label, attack])
		while stage.player.fighter.phase() != 0:
			await step(1)
		assert(target.fighter.health.current() == maxf(0, before - 16.0))
	assert(target.fighter.health.is_dead(), "Combate deve concluir sem alterar o dano")
	assert(not stage.session.player.health.is_dead())


func run() -> void:
	create_timer(65).timeout.connect(func() -> void: quit(1))
	stage = (load("res://world/lateral/lateral.tscn") as PackedScene).instantiate() as Node2D
	root.add_child(stage)
	await step(20)
	assert(stage.player.is_on_floor())
	assert(not stage.active)
	snapshot("00_menu")
	await tap(KEY_ENTER)
	assert(stage.active)
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
	await fight(stage.enemy, 3, "04_combate")
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
	await walk_to(2000)
	await fight(stage.boss, 8, "07_chefe")
	snapshot("08_chefe_derrotado")
	await walk_to(2260)
	await step(3)
	assert(stage.completed)
	assert(stage.camera.get_screen_center_position().x <= 1761.0)
	snapshot("09_encerramento")
	recording = false
	await tap(KEY_ENTER)
	assert(stage.active and not stage.completed)
	stage.session.player.health.damage(999.0)  # Somente prova da tela de derrota, após vencer.
	await step(3)
	snapshot("10_derrota_forcada")
	var dead_health: RefCounted = stage.session.player.health
	await tap(KEY_ENTER)
	assert(stage.active and dead_health.is_dead())
	assert(stage.session.player.health.current() == 100.0)
	snapshot("11_jogar_novamente")
	var old: RefCounted = stage.session
	await tap(KEY_R)
	assert(stage.session != old and not stage.completed and not stage.active)
	assert(stage.session.player.health.current() == 100.0)
	print("LATERAL_PLAYTHROUGH_OK: esquerda/direita, salto, duas plataformas, aterrissagens,")
	print("obstaculo, esqueleto e chefe derrotados, camera, encerramento e nova sessao.")
	print("CAPTURES=", picture, "; input sintetico / fisica real; nao homologacao manual.")
	if output != "":
		var file: FileAccess = FileAccess.open(output.path_join("frames.json"), FileAccess.WRITE)
		file.store_string(JSON.stringify(frame_times, "\t"))
	quit(0)

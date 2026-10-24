extends GutTest


func test_menu_start_pause_inventory_and_restart() -> void:
	var scene: PackedScene = load("res://main.tscn") as PackedScene
	var main: Node2D = scene.instantiate() as Node2D
	add_child_autofree(main)
	assert_null(main.run)
	main._start()
	assert_not_null(main.run)
	assert_eq(main.view.floor_layer.get_used_cells().size(), 576)
	assert_eq(
		main.view.floor_layer.map_to_local(Vector2i(3, 5)) + main.view.floor_layer.position,
		IsoMath.project(Vector2(3, 5))
	)
	main.run.walk_to(Vector2i(5, 5))
	press_key(main, KEY_ESCAPE)
	var before: Vector2 = main.run.player
	main._process(0.2)
	assert_eq(main.run.player, before)
	press_key(main, KEY_ESCAPE)
	main._process(0.2)
	assert_ne(main.run.player, before)
	press_key(main, KEY_I)
	before = main.run.player
	main._process(0.2)
	assert_eq(main.run.player, before)
	main.run.inventory.append("Ferro funerário")
	press_key(main, KEY_F)
	assert_true(main.run.equipped)
	press_key(main, KEY_R)
	assert_eq(main.run.inventory.size(), 0)
	assert_eq(main.run.player, Vector2(3, 3))
	assert_false(main.hud.inventory_open)


func press_key(main: Node2D, key: Key) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.physical_keycode = key
	event.pressed = true
	main._unhandled_input(event)

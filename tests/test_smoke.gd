extends GutTest


func test_main_scene() -> void:
	var scene: PackedScene = load("res://main.tscn") as PackedScene
	assert_not_null(scene)
	var main: Node2D = scene.instantiate() as Node2D
	add_child_autofree(main)
	var label: Label = main.get_node("Label") as Label
	assert_eq(label.text, "OSSUVAR")

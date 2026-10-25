class_name LateralActor
extends CharacterBody2D
## Adapter físico 2D; vida/dano pertencem aos componentes existentes.

var fighter: LateralFighter
var rules: LateralRules
var opponent: LateralActor
var enemy: bool = false
var boss: bool = false
var facing: float = 1.0
var controls_enabled: bool = true
var patrol_direction: float = -1.0
var animation_time: float = 0.0


func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	var shape: CollisionShape2D = CollisionShape2D.new()
	var capsule: CapsuleShape2D = CapsuleShape2D.new()
	var size: Vector2 = rules.boss_body_size if boss else rules.body_size
	capsule.radius = size.x / 2.0
	capsule.height = size.y
	shape.shape = capsule
	shape.position.y = -size.y / 2.0
	add_child(shape)


func request_jump() -> bool:
	if not can_control() or not is_on_floor() or fighter.phase() != LateralFighter.Phase.READY:
		return false
	velocity.y = rules.jump_velocity
	return true


func request_attack() -> bool:
	return can_control() and is_on_floor() and velocity.y >= 0.0 and fighter.begin_attack()


func can_control() -> bool:
	return controls_enabled and not fighter.health.is_dead()


func _physics_process(delta: float) -> void:
	animation_time += delta
	fighter.advance(delta, reachable_target())
	var direction: float = 0.0
	if can_control() and fighter.phase() == LateralFighter.Phase.READY:
		if enemy:
			direction = _enemy_direction()
		else:
			direction = float(
				Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT)
			)
			direction -= float(
				Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)
			)
	if direction != 0.0:
		facing = signf(direction)
	velocity.x = direction * (rules.enemy_speed if enemy else rules.speed)
	velocity.y += rules.gravity * delta
	move_and_slide()
	if position.y > rules.fall_y and not fighter.health.is_dead():
		fighter.health.damage(fighter.health.current())
	queue_redraw()


func reachable_target() -> LateralFighter:
	if not _has_opponent():
		return null
	if fighter.health.is_dead() or opponent.fighter.health.is_dead():
		return null
	var difference: Vector2 = opponent.global_position - global_position
	var reach: float = rules.enemy_reach if enemy else rules.player_reach
	if boss:
		reach = rules.boss_reach
	if difference.x * facing < 0.0 or absf(difference.x) > reach:
		return null
	if absf(difference.y) >= rules.hit_height:
		return null
	var chest: Vector2 = Vector2(0, -rules.body_size.y / 2.0)
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		global_position + chest, opponent.global_position + chest, collision_mask
	)
	query.hit_from_inside = true
	if not get_world_2d().direct_space_state.intersect_ray(query).is_empty():
		return null
	return opponent.fighter


func _has_opponent() -> bool:
	return (
		is_instance_valid(opponent)
		and opponent.is_inside_tree()
		and not opponent.is_queued_for_deletion()
	)


func _enemy_direction() -> float:
	if _has_opponent() and not opponent.fighter.health.is_dead():
		var distance: Vector2 = opponent.position - position
		if absf(distance.x) < rules.aggro:
			facing = signf(distance.x) if distance.x != 0.0 else facing
			if reachable_target() != null:
				request_attack()
				return 0.0
			return facing
	if boss:
		return 0.0
	if position.x < rules.patrol_limits.x:
		patrol_direction = 1.0
	elif position.x > rules.patrol_limits.y:
		patrol_direction = -1.0
	return patrol_direction


func _draw() -> void:
	# Silhuetas próprias vetoriais, não derivadas dos pacotes inspecionados.
	if boss:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE * 1.5)
	if fighter.health.is_dead():
		draw_line(Vector2(-18, -3), Vector2(18, -3), Color("8e918a"), 6)
		return
	var step: float = sin(animation_time * 15.0) * 6.0 if absf(velocity.x) > 1.0 else 0.0
	var color: Color = Color("d6cdb8") if enemy else Color("5bbdb0")
	if boss:
		color = Color("eaa48c")
	draw_line(Vector2(0, -25), Vector2(-8 + step, -2), color, 5)
	draw_line(Vector2(0, -25), Vector2(8 - step, -2), color, 5)
	if enemy:
		draw_line(Vector2(0, -39), Vector2(0, -22), color, 4)
		for y: int in [-35, -30, -25]:
			draw_line(Vector2(-8, y), Vector2(8, y), color, 3)
	else:
		draw_colored_polygon(
			PackedVector2Array(
				[Vector2(-11, -39), Vector2(8, -39), Vector2(14, -12), Vector2(-16, -12)]
			),
			Color("285c60")
		)
	draw_circle(Vector2(0, -47), 9, color)
	draw_rect(Rect2(Vector2(facing * 3 - 2, -49), Vector2(4, 3)), Color("17202b"))
	var phase: LateralFighter.Phase = fighter.phase()
	var weapon: Vector2 = Vector2(facing * 18, -28)
	if phase == LateralFighter.Phase.PREPARE:
		weapon = Vector2(-facing * 12, -48)
		if enemy:
			draw_circle(Vector2(0, -69), 7, Color("ffae63"))
	elif phase == LateralFighter.Phase.ACTIVE:
		weapon = Vector2(facing * 48, -25)
		draw_arc(
			Vector2(0, -28),
			47,
			-0.6 if facing > 0 else 2.5,
			0.6 if facing > 0 else 3.8,
			12,
			Color("f4df9b"),
			4
		)
	draw_line(Vector2(facing * 5, -33), weapon, color, 4)
	draw_line(weapon, weapon + Vector2(facing * 15, -17), Color("f3e1b9"), 3)

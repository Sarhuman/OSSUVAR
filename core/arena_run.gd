class_name ArenaRun
extends RefCounted
## Simulação local a 25 Hz. Sem dependência de cenas ou de frames de renderização.

signal changed
signal feedback(cell: Vector2, message: String, kind: String)

const STEP: float = 1.0 / 25.0
var rules: ArenaRules
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var grid: AStarGrid2D = AStarGrid2D.new()
var player: Vector2 = Vector2(3, 3)
var destination: Vector2i = Vector2i(3, 3)
var path: Array[Vector2i] = []
var enemies: Array[Dictionary] = []
var drops: Array[Dictionary] = []
var inventory: Array[String] = []
var walls: Array[Vector2i] = []
var health: float
var mana: float
var vigor: float
var level: int = 1
var xp: int = 0
var potions: int = 4
var kills: int = 0
var equipped: bool = false
var attack_left: int = 0
var skill_left: int = 0
var target: int = -1
var attack_flash: int = 0
var skill_flash: int = 0
var notice: String = "Clique no chão para caminhar."


func _init(config: ArenaRules) -> void:
	rules = config
	rng.seed = rules.seed_value
	health = rules.health
	mana = rules.mana
	vigor = rules.vigor
	grid.region = Rect2i(0, 0, rules.size, rules.size)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.update()
	for x: int in rules.size:
		for y: int in rules.size:
			if x == 0 or y == 0 or x == rules.size - 1 or y == rules.size - 1:
				_add_wall(Vector2i(x, y))
	for cell: Vector2i in [
		Vector2i(8, 5),
		Vector2i(8, 6),
		Vector2i(8, 7),
		Vector2i(12, 12),
		Vector2i(13, 12),
		Vector2i(16, 6),
		Vector2i(6, 15)
	]:
		_add_wall(cell)
	for i: int in rules.enemy_count:
		var cell: Vector2i = Vector2i(8 + i % 4 * 3, 9 + i / 4 * 4)
		enemies.append(
			{
				"pos": Vector2(cell),
				"hp": rules.enemy_health,
				"cooldown": 0,
				"flash": 0,
				"path": [],
				"repath": 0,
				"windup": 0
			}
		)


func _add_wall(cell: Vector2i) -> void:
	walls.append(cell)
	grid.set_point_solid(cell)


func walk_to(cell: Vector2i) -> void:
	if health <= 0.0 or not grid.is_in_boundsv(cell) or grid.is_point_solid(cell):
		return
	target = -1
	destination = cell
	path = grid.get_id_path(Vector2i(player.round()), cell)
	if not path.is_empty():
		path.pop_front()
	changed.emit()


func attack_enemy(index: int) -> void:
	if index < 0 or index >= enemies.size() or enemies[index].hp <= 0.0:
		return
	walk_to(Vector2i(enemies[index].pos.round()))
	target = index


func tick() -> void:
	if health <= 0.0:
		return
	attack_left = maxi(0, attack_left - 1)
	skill_left = maxi(0, skill_left - 1)
	attack_flash = maxi(0, attack_flash - 1)
	skill_flash = maxi(0, skill_flash - 1)
	mana = minf(rules.mana, mana + STEP * 2.0)
	if target >= 0 and enemies[target].hp > 0.0:
		if player.distance_to(enemies[target].pos) <= 1.45:
			path.clear()
			if attack_left == 0:
				attack_left = rules.attack_frames
				attack_flash = 6
				if rng.randf() <= CombatMath.hit_chance(100.0, 30.0, level, 1):
					_hurt(target, rules.player_damage + (6 if equipped else 0))
				else:
					feedback.emit(enemies[target].pos, "ERROU", "miss")
		elif path.is_empty() or destination != Vector2i(enemies[target].pos.round()):
			var old_target: int = target
			walk_to(Vector2i(enemies[target].pos.round()))
			target = old_target
	elif target >= 0:
		target = -1
	if not path.is_empty():
		player = player.move_toward(Vector2(path[0]), rules.player_speed * STEP)
		if player.distance_to(Vector2(path[0])) < 0.01:
			path.pop_front()
	for enemy: Dictionary in enemies:
		_update_enemy(enemy)
	changed.emit()


func _update_enemy(enemy: Dictionary) -> void:
	enemy.flash = maxi(0, int(enemy.flash) - 1)
	if enemy.hp <= 0.0:
		return
	enemy.cooldown = maxi(0, int(enemy.cooldown) - 1)
	var distance: float = enemy.pos.distance_to(player)
	if enemy.windup > 0:
		enemy.windup -= 1
		if enemy.windup == 0 and distance <= 1.7:
			health = maxf(0.0, health - rules.enemy_damage)
			feedback.emit(player, str(rules.enemy_damage), "hurt")
			if health == 0.0:
				notice = "Você caiu. Pressione R para recomeçar."
		return
	if distance > rules.aggro_radius:
		return
	if distance <= 1.2:
		if enemy.cooldown == 0:
			enemy.cooldown = rules.enemy_attack_frames
			enemy.windup = 10
		return
	enemy.repath -= 1
	if enemy.repath <= 0:
		enemy.path = grid.get_id_path(Vector2i(enemy.pos.round()), Vector2i(player.round()))
		if not enemy.path.is_empty():
			enemy.path.pop_front()
		enemy.repath = 8
	if not enemy.path.is_empty():
		enemy.pos = enemy.pos.move_toward(Vector2(enemy.path[0]), rules.enemy_speed * STEP)
		if enemy.pos.distance_to(Vector2(enemy.path[0])) < 0.01:
			enemy.path.pop_front()


func _hurt(index: int, damage: int) -> void:
	var enemy: Dictionary = enemies[index]
	if enemy.hp <= 0.0:
		return
	enemy.hp = maxf(0.0, float(enemy.hp) - damage)
	enemy.flash = 5
	feedback.emit(enemy.pos, str(damage), "hit")
	if enemy.hp == 0.0:
		kills += 1
		xp += rules.xp_per_enemy
		drops.append({"pos": enemy.pos, "name": "Ferro funerário", "taken": false})
		while xp >= rules.xp_per_level:
			xp -= rules.xp_per_level
			level += 1
			health = rules.health
			feedback.emit(player, "NÍVEL %d" % level, "loot")
		notice = "Aproxime-se do drop e pressione E para recolher."
		if kills == enemies.size():
			notice = "A Vigília está segura. Arena concluída! R: nova partida."


func cast_whirlwind() -> void:
	if health <= 0.0 or skill_left > 0 or mana < rules.skill_cost:
		return
	mana -= rules.skill_cost
	skill_left = rules.skill_frames
	skill_flash = 12
	for i: int in enemies.size():
		if enemies[i].pos.distance_to(player) <= rules.skill_radius:
			_hurt(i, rules.player_damage + 8)
	changed.emit()


func drink_potion() -> void:
	if health <= 0.0 or potions == 0 or health >= rules.health:
		return
	potions -= 1
	health = minf(rules.health, health + rules.health * 0.5)
	changed.emit()


func collect() -> void:
	if health <= 0.0:
		return
	for drop: Dictionary in drops:
		if not drop.taken and player.distance_to(drop.pos) < 2.0:
			if inventory.size() >= rules.inventory_capacity:
				notice = "Inventário cheio."
				break
			drop.taken = true
			inventory.append(drop.name)
			feedback.emit(player, "+ Ferro funerário", "loot")
	changed.emit()


func equip() -> void:
	if not inventory.is_empty() and health > 0.0:
		equipped = true
		notice = "Ferro funerário equipado: +6 de dano no ataque básico."
		changed.emit()

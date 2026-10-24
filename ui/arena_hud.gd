class_name ArenaHud
extends Control
## HUD isolado: barras horizontais, inventário e pausa da arena.

var run: ArenaRun
var paused: bool = false
var inventory_open: bool = false
var map_open: bool = false
var font: Font = ThemeDB.fallback_font
var accent: Color = Color("c5ad7b")


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if run == null:
		return
	var w: float = size.x
	var h: float = size.y
	draw_rect(Rect2(0, 0, w, 78), Color(0.03, 0.04, 0.035, 0.9))
	text(Vector2(28, 30), "O S S U V A R", 23, accent)
	text(Vector2(29, 54), "OS TREZE SINOS  /  PROTÓTIPO", 11, Color("919283"))
	text(Vector2(w * 0.46, 31), "VIGÍLIA DE CAL", 18, Color("d3d0b9"))
	text(
		Vector2(w * 0.46, 52),
		"Arena de combate · Semente %d" % run.rules.seed_value,
		11,
		Color("919283")
	)
	text(Vector2(w - 235, 31), "PENITENTE  ·  NÍVEL %d" % run.level, 14, accent)
	text(
		Vector2(w - 235, 53),
		"%d / %d mortos silenciados" % [run.kills, run.enemies.size()],
		12,
		Color("b1b3a2")
	)
	draw_line(Vector2(0, 78), Vector2(w, 78), Color("4b4a3b"))
	draw_rect(Rect2(0, h - 128, w, 128), Color(0.035, 0.045, 0.04, 0.97))
	draw_line(Vector2(0, h - 128), Vector2(w, h - 128), Color("5b5340"))
	var bar_w: float = minf(265, w * 0.23)
	bar(Vector2(28, h - 96), bar_w, run.health, run.rules.health, "VIDA", Color("a75448"))
	bar(Vector2(28, h - 65), bar_w, run.mana, run.rules.mana, "MANA", Color("587d92"))
	bar(Vector2(28, h - 34), bar_w, run.vigor, run.rules.vigor, "VIGOR", Color("85864e"))
	text(Vector2(330, h - 99), "FERRO", 11, accent)
	text(Vector2(330, h - 74), "Ataque básico", 16, Color("dbd6bf"))
	text(Vector2(330, h - 52), "Clique no inimigo", 12, Color("969d8f"))
	text(Vector2(535, h - 99), "GIRO CEIFADOR", 11, accent)
	text(Vector2(535, h - 74), "Botão direito", 16, Color("dbd6bf"))
	text(
		Vector2(535, h - 52),
		"%d mana · %.1fs" % [int(run.rules.skill_cost), float(run.skill_left) * ArenaRun.STEP],
		12,
		Color("969d8f")
	)
	text(Vector2(w - 265, h - 99), "[1–4] POÇÃO  ×%d" % run.potions, 14, accent)
	text(Vector2(w - 265, h - 73), "[I] Inventário    [E] Recolher", 13, Color("c7c7b3"))
	text(Vector2(w - 265, h - 49), "[Tab] Mapa    [Esc] Pausa", 13, Color("969d8f"))
	text(Vector2(330, h - 22), "XP", 10, accent)
	draw_rect(Rect2(356, h - 31, w - 658, 5), Color("282c25"))
	draw_rect(Rect2(356, h - 31, (w - 658) * run.xp / run.rules.xp_per_level, 5), accent)
	draw_rect(Rect2(22, h - 173, w - 44, 30), Color(0.04, 0.05, 0.04, 0.8))
	text(Vector2(35, h - 153), run.notice, 13, Color("d1c9aa"))
	if map_open:
		_draw_map(Vector2(w - 204, 110))
	if inventory_open:
		_draw_inventory(Vector2(w - 350, 100))
	if paused or run.health <= 0.0:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.015, 0.02, 0.015, 0.8))
		text(
			Vector2(w * 0.5 - 150, h * 0.5 - 25),
			"A VIGÍLIA AGUARDA" if run.health > 0 else "O PÓ TE RECLAMA",
			27,
			accent
		)
		text(
			Vector2(w * 0.5 - 150, h * 0.5 + 15),
			"Esc: continuar  ·  R: recomeçar",
			16,
			Color("d1c9aa")
		)


func text(at: Vector2, value: String, font_size: int, color: Color) -> void:
	draw_string(font, at, value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)


func bar(
	at: Vector2, width: float, value: float, maximum: float, label: String, color: Color
) -> void:
	draw_rect(Rect2(at, Vector2(width, 21)), Color("272d27"))
	draw_rect(Rect2(at + Vector2.ONE, Vector2((width - 2) * value / maximum, 19)), color)
	draw_rect(Rect2(at, Vector2(width, 21)), Color("6b6853"), false)
	text(
		at + Vector2(7, 15), "%s  %d / %d" % [label, int(value), int(maximum)], 11, Color("eee8d2")
	)


func _draw_inventory(at: Vector2) -> void:
	draw_rect(Rect2(at, Vector2(320, 380)), Color("111a16"))
	draw_rect(Rect2(at, Vector2(320, 380)), accent, false)
	text(at + Vector2(20, 32), "INVENTÁRIO", 21, accent)
	text(
		at + Vector2(20, 57),
		"Ferro funerário  ·  %d / 12" % run.inventory.size(),
		13,
		Color("bec1b0")
	)
	for i: int in 12:
		var slot: Vector2 = at + Vector2(20 + i % 4 * 69, 80 + i / 4 * 69)
		draw_rect(Rect2(slot, Vector2(60, 60)), Color("222c25"))
		draw_rect(Rect2(slot, Vector2(60, 60)), Color("4b5343"), false)
		if i < run.inventory.size():
			draw_line(slot + Vector2(20, 45), slot + Vector2(41, 12), accent, 5)
			draw_line(slot + Vector2(20, 25), slot + Vector2(36, 35), Color("ddd2ac"), 3)
	text(at + Vector2(20, 325), "[F] Equipar ferro: +6 dano básico", 13, accent)
	text(
		at + Vector2(20, 350),
		"Equipado" if run.equipped else "Sem equipamento",
		13,
		Color("a5b098")
	)


func _draw_map(at: Vector2) -> void:
	draw_rect(Rect2(at - Vector2(10, 10), Vector2(182, 182)), Color(0.04, 0.06, 0.05, 0.9))
	for wall: Vector2i in run.walls:
		draw_rect(Rect2(at + Vector2(wall) * 6.0, Vector2(5, 5)), Color("737662"))
	for enemy: Dictionary in run.enemies:
		if enemy.hp > 0.0:
			draw_circle(at + enemy.pos * 6.0, 2, Color("ae644c"))
	draw_circle(at + run.player * 6.0, 3, accent)

extends Control

const PECES_ESPECIALES: int = 2
const DIFICULTAD_MAXIMA: int = 6

var special_fish := []

var tween_1: Tween
var tween_2: Tween
var tween_3: Tween

#region Preloads
@onready var ojo = preload("res://ui/hud/art/rules/ojo.png")

@onready var procesable = preload("res://ui/hud/art/rules/procesable.png")
@onready var toxico = preload("res://ui/hud/art/rules/toxico.png")
@onready var peligrosidad = [toxico, procesable]

@onready var cabeza_manchas = preload("res://ui/hud/art/rules/cabeza_manchas.png")
@onready var cabeza_fumador = preload("res://ui/hud/art/rules/cabeza_cigarro.png")
@onready var cabeza_sombrero = preload("res://ui/hud/art/rules/cabeza_sombrero.png")
@onready var tipo_cabeza = [null, cabeza_manchas, cabeza_sombrero, cabeza_fumador]

@onready var cola_delgada = preload("res://ui/hud/art/rules/cola_delgada.png")
@onready var cola_redonda = preload("res://ui/hud/art/rules/cola_redonda.png")
@onready var cola_abanico = preload("res://ui/hud/art/rules/cola_abanico.png")
@onready var cola_manchas = preload("res://ui/hud/art/rules/cola_manchas.png")
@onready var tipo_cola = [cola_delgada, cola_redonda, cola_abanico, cola_manchas]

@onready var pez_restante_encendido = preload("res://ui/hud/art/rules/icono_pez_encendido.png")
@onready var pez_restante_apagado = preload("res://ui/hud/art/rules/icono_pez_apagado.png")

@onready var score_label: Label = $PuntuacionYTiempo/TextureRect2/Score
@onready var timer_label: Label = $PuntuacionYTiempo/TextureRect/Timer

@onready var ojos_label: Label = %OjosLabel
@onready var danger_1: TextureRect = %Danger1
@onready var regla_cabeza: TextureRect = %ReglaCabeza
@onready var cabeza_label: Label = %CabezaLabel
@onready var danger_2: TextureRect = %Danger2
@onready var cola_label: Label = %ColaLabel
@onready var regla_cola: TextureRect = %ReglaCola
@onready var danger_3: TextureRect = %Danger3

@onready var rule_1: HBoxContainer = %Rule1
@onready var rule_2: HBoxContainer = %Rule2
@onready var rule_3: HBoxContainer = %Rule3

@onready var contenedor_peces_restantes: HBoxContainer = $ReglasYPecesRestantes/PecesRestantes/ContenedorPecesRestantes
@onready var contenedor_vidas_restantes: HBoxContainer = $ReglasYPecesRestantes/VidasRestantes/ContenedorVidasRestantes

@onready var bombilla_off = preload("res://ui/hud/art/cronometro y puntuación/bombilla.png")
@onready var bombilla_acierto = preload("res://ui/hud/art/cronometro y puntuación/bombilla_encendida.png")
@onready var bombilla_error = preload("res://ui/hud/art/cronometro y puntuación/bombilla_roja.png")
@onready var bombilla: TextureRect = $PuntuacionYTiempo/Bombilla
@onready var bombilla2: TextureRect = $PuntuacionYTiempo/Bombilla2
@onready var bombilla3: TextureRect = $PuntuacionYTiempo/Bombilla3
@onready var bombillas = [bombilla, bombilla2, bombilla3]
@onready var static_shader: TextureRect = $ReglasYPecesRestantes/Reglas/StaticShader

#endregion


func _ready():
	GameHandler.time_changed.connect(_on_time_changed)
	GameHandler.score_changed.connect(_on_score_changed)
	GameHandler.fishes_left_changed.connect(_on_fishes_changed)
	GameHandler.change_rules.connect(change_rules_visuals)
	GameHandler.reset_fishes.connect(_reset_set)
	GameHandler.update_hearts.connect(on_update_hearts)
	GameHandler.update_max_life.connect(on_update_max_life)
	GameHandler.rules_error.connect(on_rules_error)
	GameHandler.changed_fish_tutorial.connect(on_changed_initial_fish)

	var hearts = contenedor_vidas_restantes.get_children()
	for i in range(hearts.size()):
		hearts[i].visible = true


func on_rules_error(values: Array) -> void:
	if values[0]:
		rule_1.modulate = Color.RED
		if tween_1:
			tween_1.kill()
		tween_1 = create_tween()
		tween_1.tween_property(rule_1, "modulate", Color.WHITE, 2.0)
	if values[1]:
		rule_2.modulate = Color.RED
		if tween_2:
			tween_2.kill()
		tween_2 = create_tween()
		tween_2.tween_property(rule_2, "modulate", Color.WHITE, 2.0)
	if values[2]:
		rule_3.modulate = Color.RED
		if tween_3:
			tween_3.kill()
		tween_3 = create_tween()
		tween_3.tween_property(rule_3, "modulate", Color.WHITE, 2.0)


func reset_peces_restantes() -> void:
	var hijos_contenedor = contenedor_peces_restantes.get_children()
	special_fish.clear()

	var chance = get_special_spawn_chance()

	for i in range(10):
		hijos_contenedor[i].texture = pez_restante_encendido
		var is_special: bool = randf() < chance
		special_fish.append(is_special)
		if is_special:
			hijos_contenedor[i].modulate = Color("ce002f")


func change_rules_visuals(rules: Array, proc_rules: Array):
	print("UPDATING RULES")
	var tween = get_tree().create_tween()
	static_shader.modulate = Color.WHITE
	tween.tween_property(static_shader, "modulate", Color(1, 1, 1, 0), 0.5)
	# Ojos
	ojos_label.text = ">" + str(rules[0] + 1)
	danger_1.texture = peligrosidad[proc_rules[0]]

	# Cabeza
	if rules[1] == 0:
		rule_2.visible = false
	else:
		rule_2.visible = true

		regla_cabeza.texture = tipo_cabeza[rules[1]]
		cabeza_label.text = " = "
		danger_2.texture = peligrosidad[proc_rules[1]]

	# Cola
	regla_cola.texture = tipo_cola[rules[2]]
	cola_label.text = " = "
	danger_3.texture = peligrosidad[proc_rules[2]]


func on_update_max_life(max_life: int):
	var hearts = contenedor_vidas_restantes.get_children()
	for i in range(max_life, hearts.size()):
		hearts[i].visible = false


func get_special_spawn_chance() -> float:
	var lvl: int = GameHandler.level
	var chance: float = 0.0

	if lvl >= DIFICULTAD_MAXIMA:
		chance = 1.0
	elif lvl >= PECES_ESPECIALES:
		# lvl 5 -> 5+1 /6+1 = 0.857
		# lvl 4 -> 4+1 / 6+1 = 0.714
		# lvl 3 -> 3+1 / 6+1 = 0.571
		# lvl 2 -> 2+1 / 6+1 = 0.428
		chance = (lvl + 1.0) / (DIFICULTAD_MAXIMA + 1.0)

	return chance


func on_update_hearts(life_idx: int, restore: bool) -> void:
	var vidas = contenedor_vidas_restantes.get_children()
	if restore:
		vidas[life_idx].set_modulate(Color("ffffffff"))
	else:
		vidas[life_idx].set_modulate(Color("0000b4ff"))


func _reset_set(_value) -> void:
	reset_peces_restantes()


func _on_time_changed(value) -> void:
	timer_label.text = str(snapped(value, 0.1)) + "0"


func _on_score_changed(score, value):
	for b in bombillas:
		b.texture = bombilla_off

	if value < 0:
		for i in range(abs(value)):
			if i < bombillas.size():
				bombillas[i].texture = bombilla_error
	else:
		for i in range(value):
			if i < bombillas.size():
				bombillas[i].texture = bombilla_acierto

	score_label.text = str(score)


func _on_fishes_changed(value) -> void:
	var hijos_contenedor = contenedor_peces_restantes.get_children()
	hijos_contenedor[value].texture = pez_restante_apagado
	# Turn off modulate change of special fishes
	hijos_contenedor[value].modulate = Color(1, 1, 1)
	if special_fish.size() > value and special_fish[value]:
		GameHandler.randomize_rules()


func on_changed_initial_fish() -> void:
	special_fish[9] = true
	var hijos_contenedor = contenedor_peces_restantes.get_children()
	hijos_contenedor[9].modulate = Color("ce002f")

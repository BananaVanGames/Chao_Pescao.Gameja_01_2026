extends Control

#endregion
const PECES_ESPECIALES: int = 2
const DIFICULTAD_MAXIMA: int = 6

# true/false per fish slot
var special_fish := []

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

@onready var danger_1: TextureRect = $ReglasYPecesRestantes/Reglas/GridContainer/Danger1
@onready var danger_2: TextureRect = $ReglasYPecesRestantes/Reglas/GridContainer/Danger2
@onready var danger_3: TextureRect = $ReglasYPecesRestantes/Reglas/GridContainer/Danger3
@onready var grid_container: GridContainer = $ReglasYPecesRestantes/Reglas/GridContainer
@onready var regla_cola: TextureRect = $ReglasYPecesRestantes/Reglas/GridContainer/ReglaCola

@onready var contenedor_peces_restantes: HBoxContainer = $ReglasYPecesRestantes/PecesRestantes/ContenedorPecesRestantes
@onready var contenedor_vidas_restantes: HBoxContainer = $ReglasYPecesRestantes/VidasRestantes/ContenedorVidasRestantes

@onready var bombilla_off = preload("res://ui/hud/art/cronometro y puntuación/bombilla.png")
@onready var bombilla_acierto = preload("res://ui/hud/art/cronometro y puntuación/bombilla_encendida.png")
@onready var bombilla_error = preload("res://ui/hud/art/cronometro y puntuación/bombilla_roja.png")
@onready var bombilla: TextureRect = $PuntuacionYTiempo/Bombilla
@onready var bombilla2: TextureRect = $PuntuacionYTiempo/Bombilla2
@onready var bombilla3: TextureRect = $PuntuacionYTiempo/Bombilla3
@onready var bombillas = [bombilla, bombilla2, bombilla3]


func _ready():
	GameHandler.time_changed.connect(_on_time_changed)
	GameHandler.score_changed.connect(_on_score_changed)
	GameHandler.fishes_left_changed.connect(_on_fishes_changed)
	GameHandler.change_rules.connect(change_rules_visuals)
	GameHandler.reset_fishes.connect(_reset_set)
	GameHandler.update_hearts.connect(on_update_hearts)
	GameHandler.update_max_life.connect(on_update_max_life)

	print("REINICIANDO CORAZONES")
	var hearts = contenedor_vidas_restantes.get_children()
	for i in range(hearts.size()):
		hearts[i].visible = true


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
	var grid_children = grid_container.get_children()

	# Ojos
	grid_children[1].text = ">" + str(rules[0] + 1)
	danger_1.texture = peligrosidad[proc_rules[0]]

	# Cabeza
	if rules[1] == 0:
		grid_children[3].visible = false
		grid_children[4].visible = false
		danger_2.visible = false
	else:
		grid_children[3].visible = true
		grid_children[4].visible = true
		grid_children[3].texture = tipo_cabeza[rules[1]]
		grid_children[4].text = "   =   "
		danger_2.visible = true
		danger_2.texture = peligrosidad[proc_rules[1]]

	# Cola
	regla_cola.texture = tipo_cola[rules[2]]
	grid_children[7].text = "   =   "
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
		# lvl 5 -> (5 - 2) / 4 = 3 / 4 = 0.75
		# lvl 4 -> (4 - 2) / 4 = 1 / 2 = 0.5
		# lvl 3 -> (3 - 2) / 4 = 1 / 4 = 0.25
		var level_range: float = DIFICULTAD_MAXIMA - PECES_ESPECIALES
		chance = float(lvl - PECES_ESPECIALES) / level_range

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

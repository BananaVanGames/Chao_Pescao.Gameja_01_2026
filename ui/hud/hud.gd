extends Control

#endregion
var is_muted: bool = false

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
	GameHandler.change_rules.connect(_start_next_set)
	GameHandler.reset_fishes.connect(_reset_set)


func reset_peces_restantes() -> void:
	var hijos_contenedor = contenedor_peces_restantes.get_children()
	for i in range(10):
		hijos_contenedor[i].texture = pez_restante_encendido


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


func _start_next_set(value: Array):
	var random_ojos: int
	var random_cabeza: int
	var random_cola: int
	var grid_children = grid_container.get_children()

	for i in range(3):
		match i:
			0:
				random_ojos = randi_range(0, 1)
				grid_children[i * 3 + 1].text = ">" + str(value[i] + 1)
				danger_1.texture = peligrosidad[random_ojos]

			1:
				if value[i] == 0:
					grid_children[i * 3].visible = false
					grid_children[i * 3 + 1].visible = false
					danger_2.visible = false
				else:
					grid_children[i * 3].visible = true
					grid_children[i * 3 + 1].visible = true
					danger_2.visible = true

					grid_children[i * 3].texture = tipo_cabeza[value[i]]
					grid_children[i * 3 + 1].text = "   =   "
					random_cabeza = randi_range(0, 1)
					danger_2.texture = peligrosidad[random_cabeza]

			2:
				regla_cola.texture = tipo_cola[value[i]]

				grid_children[i * 3 + 1].text = "   =   "

				random_cola = randi_range(0, 1)
				danger_3.texture = peligrosidad[random_cola]

	GameHandler.set_processable_rules([random_ojos, random_cabeza, random_cola])

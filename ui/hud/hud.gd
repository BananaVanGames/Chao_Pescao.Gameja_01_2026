extends Control

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

@onready var score_label: Label = $Consola/Score/Score
@onready var timer_label: Label = $Consola/Timer/Timer

@onready var consolita = preload("res://ui/hud/art/cronometro y puntuación/consola.png")
@onready var bombilla1 = preload("res://ui/hud/art/cronometro y puntuación/consola_bombilla1.png")
@onready var bombilla2 = preload("res://ui/hud/art/cronometro y puntuación/consola_bombilla2.png")
@onready var bombilla3 = preload("res://ui/hud/art/cronometro y puntuación/consola_bombilla3.png")

@onready var danger_1: TextureRect = $Reglas/GridContainer/Danger1
@onready var danger_2: TextureRect = $Reglas/GridContainer/Danger2
@onready var danger_3: TextureRect = $Reglas/GridContainer/Danger3
@onready var grid_container: GridContainer = $Reglas/GridContainer
@onready var regla_cola: TextureRect = $Reglas/GridContainer/ReglaCola
@onready var contenedor_peces_restantes: HBoxContainer = $PecesRestantes/ContenedorPecesRestantes
@onready var consola: TextureRect = $Consola

#endregion
var is_muted: bool = false

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


func _on_score_changed(total_score, tmp_score):
	if tmp_score == 1:
		consola.texture = bombilla1
	elif tmp_score == 2:
		consola.texture = bombilla2
	elif tmp_score == 3:
		consola.texture = bombilla3
	else:
		consola.texture = consolita
	score_label.text = str(total_score)


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

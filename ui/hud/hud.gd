extends Control

@onready var ojo = preload("res://ui/hud/art/ojo.png")

@onready var procesable = preload("res://ui/hud/art/procesable.png")
@onready var toxico = preload("res://ui/hud/art/toxico.png")
@onready var peligrosisdad = [toxico, procesable]

@onready var cabeza_manchas = preload("res://ui/hud/art/cabeza_manchas.png")
@onready var cabeza_fumador = preload("res://ui/hud/art/cabeza_cigarro.png")
@onready var cabeza_sombrero = preload("res://ui/hud/art/cabeza_sombrero.png")
@onready var tipo_cabeza = [cabeza_manchas, cabeza_fumador, cabeza_sombrero]

@onready var cola_delgada = preload("res://ui/hud/art/cola_delgada.png")
@onready var cola_redonda = preload("res://ui/hud/art/cola_redonda.png")
@onready var cola_abanico = preload("res://ui/hud/art/cola_abanico.png")
@onready var cola_manchas = preload("res://ui/hud/art/cola_manchas.png")
@onready var tipo_cola = [cola_delgada, cola_redonda, cola_abanico, cola_manchas]

@onready var score_label: Label = $Node2D/Score
@onready var timer_label: Label = $Node2D2/Timer
@onready var fishes_left_label: Label = $FishesLeft
@onready var danger_1: TextureRect = $GridContainer/Danger1
@onready var danger_2: TextureRect = $GridContainer/Danger2
@onready var danger_3: TextureRect = $GridContainer/Danger3
@onready var grid_container: GridContainer = $GridContainer
@onready var regla_cola: TextureRect = $GridContainer/ReglaCola


func _ready():
	GameHandler.time_changed.connect(_on_time_changed)
	GameHandler.score_changed.connect(_on_score_changed)
	GameHandler.fishes_left_changed.connect(_on_fishes_changed)
	GameHandler.change_rules.connect(_start_next_set)


func _on_time_changed(value):
	timer_label.text = str(snapped(value, 0.1)) + "0"


func _on_score_changed(value):
	score_label.text = str(value)


func _on_fishes_changed(value):
	fishes_left_label.text = "PESCADOS RESTANTES: " + str(value)


func _start_next_set(value: Array):
	var random_ojos: int
	var random_cabeza: int
	var random_cola: int
	var grid_children = grid_container.get_children()
	for i in range(3):
		match i:
			0:
				random_ojos = randi_range(0, 1)
				grid_children[i * 3 + 1].text = " > " + str(value[i] + 1) + " "
				danger_1.texture = peligrosisdad[random_ojos]

			1:
				if value[i] == 0:
					grid_children[i * 3].visible = false
					grid_children[i * 3 + 1].visible = false
					danger_2.visible = false
				else:
					var random = randi_range(0, 1)
					grid_children[i * 3].texture = tipo_cabeza[random]

					grid_children[i * 3 + 1].text = " = "

					random_cabeza = randi_range(0, 1)
					danger_2.texture = peligrosisdad[random_cabeza]

			2:
				var random = randi_range(0, 2)
				regla_cola.texture = tipo_cola[random]

				grid_children[i * 3 + 1].text = " = "

				random_cola = randi_range(0, 1)
				danger_3.texture = peligrosisdad[random_cola]

	GameHandler.set_danger_rules([random_ojos, random_cabeza, random_cola])

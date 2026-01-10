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

@onready var timer_label: Label = $VBoxContainer/Timer
@onready var score_label: Label = $VBoxContainer/Score
@onready var fishes_left_label: Label = $VBoxContainer/FishesLeft
@onready var danger_1: TextureRect = $GridContainer/Danger1
@onready var danger_2: TextureRect = $GridContainer/Danger2
@onready var danger_3: TextureRect = $GridContainer/Danger3
@onready var danger_4: TextureRect = $GridContainer/Danger4
@onready var grid_container: GridContainer = $GridContainer
@onready var regla_cola: TextureRect = $GridContainer/ReglaCola


func _ready():
	GameHandler.time_changed.connect(_on_time_changed)
	GameHandler.score_changed.connect(_on_score_changed)
	GameHandler.fishes_left_changed.connect(_on_fishes_changed)
	GameHandler.change_rules.connect(_start_next_set)


func _on_time_changed(value):
	timer_label.text = "TIEMPO: %d" % int(ceil(value))


func _on_score_changed(value):
	score_label.text = "SCORE: %d" % value


func _on_fishes_changed(value):
	fishes_left_label.text = "PESCADOS RESTANTES: %d" % value


func _start_next_set(value: Array):
	#print("Value received: ", value)
	var grid_children = grid_container.get_children()
	#print("HIJOS DEL GRID: ", grid_children)
	for i in range(4):
		match i:
			0:
				var random = randi_range(0, 1)
				#print("VALUE OF RANDOM - PELIGROSIDDAD OJOS: ", random)
				grid_children[i * 3 + 1].text = " > " + str(value[i] + 1) + " "
				danger_1.texture = peligrosisdad[random]

			1:
				if value[i] == 0:
					grid_children[i * 3].visible = false
					grid_children[i * 3 + 1].visible = false
					danger_2.visible = false
				else:
					var random = randi_range(0, 1)
					grid_children[i * 3].texture = tipo_cabeza[random]

					grid_children[i * 3 + 1].text = " = "

					random = randi_range(0, 1)
					danger_2.texture = peligrosisdad[random]

			2:
				if value[i] == 0:
					grid_children[i * 3].visible = false
					grid_children[i * 3 + 1].visible = false
					danger_3.visible = false

			3:
				var random = randi_range(0, 2)
				#print("VALUE OF RANDOM - TIPO COLA: ", random)
				regla_cola.texture = tipo_cola[random]

				grid_children[i * 3 + 1].text = " = "

				random = randi_range(0, 1)
				danger_4.texture = peligrosisdad[random]

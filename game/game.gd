extends Node2D

enum PELIGROSIDAD {
	TOXICO,
	PROCESABLE,
}

@export var fish_scene: PackedScene
@export var round_time: float = 5
@export var level: int = -1

# POSIBLES PECES A SPAWNEAR = [OJOS, CABEZA, CUERPO, COLA]
var peces_posibles1: Array = [[1], [0, 1], [0], [0, 1, 2]]
var peces_posibles2: Array = [[0, 1, 2, 3], [0, 1], [0, 1], [0, 1, 2]]
var peces_posibles3: Array = [[0, 1, 2, 3, 4, 5], [0, 1, 2, 3], [0, 1], [0, 1, 2, 3]]
var peces_posibles: Array = [peces_posibles1, peces_posibles2, peces_posibles3]

# PECES PELIGROSOS: 
var peces_peligrosos1: Array = [[1], [0, 1], [0], [0, 1, 2]]
var peces_peligrosos2: Array = [[3, 4, 5], [0, 1, 2], [0, 1], [0, 1, 2, 3]]
var peces_peligrosos3: Array = [[3, 4, 5, 6], [0, 1, 2, 3], [0, 1], [0, 1, 2, 3]]
var peces_peligrosos: Array = [peces_peligrosos1, peces_peligrosos2, peces_peligrosos3]

@onready var timer: Timer = $Timer
@onready var spawner: Marker2D = $Spawner


func _ready() -> void:
	start_next_set()
	start_round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer.is_stopped():
		return

	GameHandler.set_time(timer.time_left)


func start_next_set():
	level += 1
	if level > 3:
		game_over()

	var rules: Array
	for i in range(4):
		rules.append(peces_peligrosos[level][i].pick_random())

	print("Las reglas de peces peligrosos son: ", rules)
	GameHandler.start_next_set(rules)


func start_round():
	GameHandler.set_time(round_time)
	timer.start(round_time)
	spawn_fish()


func game_over():
	pass


func spawn_fish():
	if GameHandler.fishes_left <= 0:
		end_game()
		return

	var fish = fish_scene.instantiate()
	spawner.add_child(fish)
	fish.global_position = spawner.global_position

	GameHandler.set_fishes_left(GameHandler.fishes_left - 1)


func end_game():
	timer.stop()
	print("Game Over")


func _on_timer_timeout() -> void:
	start_round()

extends Node2D

@export var fish_scene: PackedScene
@export var round_time: float = 5.00

@onready var timer: Timer = $Timer
@onready var spawner: Marker2D = $Spawner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer.is_stopped():
		return

	GameHandler.set_time(timer.time_left)


func start_round():
	GameHandler.set_time(round_time)
	timer.start(round_time)
	spawn_fish()


func spawn_fish():
	if GameHandler.fishes_left <= 0:
		end_game()
		return

	var fish = fish_scene.instantiate()
	spawner.add_child(fish)
	fish.global_position = spawner.global_position

	GameHandler.set_fishes_left(GameHandler.fishes_left - 1)


func end_game():
	get_tree().quit()
	print("Game Over")


func _on_timer_timeout() -> void:
	$Punch.trigger_punch()
	start_round()

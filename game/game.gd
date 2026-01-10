extends Node2D

@export var fish_scene: PackedScene
@export var round_time := 5.5
@export var punch_time := 0.5


@onready var timer: Timer = $Timer
@onready var punch_timer: Timer = $PunchTimer
@onready var spawner: Marker2D = $Spawner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	punch_timer.timeout.connect(_on_punch_timer_timeout)

	start_round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer.is_stopped():
		return

	GameHandler.set_time(timer.time_left)

func start_round():
	GameHandler.set_time(round_time)
	timer.start(round_time)
	
func _on_timer_timeout() -> void:
	GameHandler.set_time(0)
	punch_timer.start(punch_time)
	
func _on_punch_timer_timeout() -> void:
	spawn_fish()
	start_round()


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
	punch_timer.stop()
	print("Game Over")

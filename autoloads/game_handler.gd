extends Node

signal time_changed(value)
signal score_changed(value)
signal fishes_left_changed(value)

var time_left := 5
var score := 0
var fishes_left := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_time(value: float):
	time_left = value
	emit_signal("time_changed", time_left)

func add_score(value: int):
	score += value
	emit_signal("score_changed", score)

func set_fishes_left(value: int):
	fishes_left = value
	emit_signal("fishes_left_changed", fishes_left)
	
func reset():
	set_time(5)
	score = 0
	set_fishes_left(10)

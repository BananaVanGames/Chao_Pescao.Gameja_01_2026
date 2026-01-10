extends Node

signal time_changed(value)
signal score_changed(value)
signal fishes_left_changed(value)
signal change_rules(value)

var time_left: float = 5
var score: int = 0
var fishes_left: int = 10
var rules: Array = []
var danger_rules: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_danger_rules(values: Array):
	danger_rules = values


func get_danger_rules() -> Array:
	return danger_rules


func get_current_rules() -> Array:
	return rules


func start_next_set(value: Array):
	rules = value
	#print("Rules recibidas: ", rules)
	emit_signal("change_rules", rules)


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

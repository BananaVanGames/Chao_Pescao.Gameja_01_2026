extends Node

signal time_changed(value)
signal score_changed(value)
signal fishes_left_changed(value)
signal change_rules(value)
signal open_door
signal reset_fishes(value)

var time_left: float = 5
var score: int = 0
var fishes_left: int = 10
var rules: Array = []
var danger_rules: Array = []


func set_danger_rules(values: Array):
	danger_rules = values


func get_danger_rules() -> Array:
	return danger_rules


func open_door_animation():
	emit_signal("open_door")


func get_current_rules() -> Array:
	return rules


func start_next_set(value: Array):
	rules = value
	#print("Rules recibidas: ", rules)
	emit_signal("change_rules", rules)


func set_time(value: float):
	time_left = value
	emit_signal("time_changed", time_left)


func get_time() -> float:
	return time_left


func add_score(value: int):
	score += value
	emit_signal("score_changed", score, value)


func set_fishes_left(value: int):
	fishes_left = value
	emit_signal("fishes_left_changed", fishes_left)


func reset_fish(value: int):
	fishes_left = value
	emit_signal("reset_fishes", fishes_left)


func reset():
	set_time(5)
	reset_fish(10)

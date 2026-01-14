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

#region Fish paths

var paths_level_1 := [
	"res://game/pez/art/0,0,0,0.png",
	"res://game/pez/art/0,0,0,1.png",
	"res://game/pez/art/0,0,0,2.png",
	"res://game/pez/art/0,1,0,0.png",
	"res://game/pez/art/0,1,0,1.png",
	"res://game/pez/art/0,1,0,2.png",
	"res://game/pez/art/1,0,0,0.png",
	"res://game/pez/art/1,0,0,1.png",
	"res://game/pez/art/1,0,0,2.png",
	"res://game/pez/art/1,1,0,0.png",
	"res://game/pez/art/1,1,0,1.png",
	"res://game/pez/art/1,1,0,2.png",
	"res://game/pez/art/2,0,0,0.png",
	"res://game/pez/art/2,0,0,1.png",
	"res://game/pez/art/2,0,0,2.png",
	"res://game/pez/art/2,1,0,0.png",
	"res://game/pez/art/2,1,0,1.png",
	"res://game/pez/art/2,1,0,2.png",
]

var paths_level_2 := [
	"res://game/pez/art/0,0,1,0.png",
	"res://game/pez/art/0,0,1,1.png",
	"res://game/pez/art/0,0,1,2.png",
	"res://game/pez/art/0,0,1,3.png",
	"res://game/pez/art/0,1,1,0.png",
	"res://game/pez/art/0,1,1,1.png",
	"res://game/pez/art/0,1,1,2.png",
	"res://game/pez/art/0,1,1,3.png",
	"res://game/pez/art/0,0,0,3.png",
	"res://game/pez/art/0,1,0,3.png",
	"res://game/pez/art/0,2,0,0.png",
	"res://game/pez/art/0,2,0,1.png",
	"res://game/pez/art/0,2,0,2.png",
	"res://game/pez/art/0,2,0,3.png",
	"res://game/pez/art/0,2,1,0.png",
	"res://game/pez/art/0,2,1,1.png",
	"res://game/pez/art/0,2,1,2.png",
	"res://game/pez/art/0,2,1,3.png",
	"res://game/pez/art/1,0,0,3.png",
	"res://game/pez/art/1,0,1,0.png",
	"res://game/pez/art/1,0,1,1.png",
	"res://game/pez/art/1,0,1,2.png",
	"res://game/pez/art/1,0,1,3.png",
	"res://game/pez/art/1,1,0,3.png",
	"res://game/pez/art/1,1,1,0.png",
	"res://game/pez/art/1,1,1,1.png",
	"res://game/pez/art/1,1,1,2.png",
	"res://game/pez/art/1,1,1,3.png",
	"res://game/pez/art/1,2,0,0.png",
	"res://game/pez/art/1,2,0,1.png",
	"res://game/pez/art/1,2,0,2.png",
	"res://game/pez/art/1,2,0,3.png",
	"res://game/pez/art/1,2,1,0.png",
	"res://game/pez/art/1,2,1,1.png",
	"res://game/pez/art/1,2,1,2.png",
	"res://game/pez/art/1,2,1,3.png",
	"res://game/pez/art/2,0,0,3.png",
	"res://game/pez/art/2,0,1,0.png",
	"res://game/pez/art/2,0,1,1.png",
	"res://game/pez/art/2,0,1,2.png",
	"res://game/pez/art/2,0,1,3.png",
	"res://game/pez/art/2,1,0,3.png",
	"res://game/pez/art/2,1,1,0.png",
	"res://game/pez/art/2,1,1,1.png",
	"res://game/pez/art/2,1,1,2.png",
	"res://game/pez/art/2,1,1,3.png",
	"res://game/pez/art/2,2,0,0.png",
	"res://game/pez/art/2,2,0,1.png",
	"res://game/pez/art/2,2,0,2.png",
	"res://game/pez/art/2,2,0,3.png",
	"res://game/pez/art/2,2,1,0.png",
	"res://game/pez/art/2,2,1,1.png",
	"res://game/pez/art/2,2,1,2.png",
	"res://game/pez/art/2,2,1,3.png",
	"res://game/pez/art/3,0,0,0.png",
	"res://game/pez/art/3,0,0,1.png",
	"res://game/pez/art/3,0,0,2.png",
	"res://game/pez/art/3,0,0,3.png",
	"res://game/pez/art/3,0,1,0.png",
	"res://game/pez/art/3,0,1,1.png",
	"res://game/pez/art/3,0,1,2.png",
	"res://game/pez/art/3,0,1,3.png",
	"res://game/pez/art/3,1,0,0.png",
	"res://game/pez/art/3,1,0,1.png",
	"res://game/pez/art/3,1,0,2.png",
	"res://game/pez/art/3,1,0,3.png",
	"res://game/pez/art/3,1,1,0.png",
	"res://game/pez/art/3,1,1,1.png",
	"res://game/pez/art/3,1,1,2.png",
	"res://game/pez/art/3,1,1,3.png",
	"res://game/pez/art/3,2,0,0.png",
	"res://game/pez/art/3,2,0,1.png",
	"res://game/pez/art/3,2,0,2.png",
	"res://game/pez/art/3,2,0,3.png",
	"res://game/pez/art/3,2,1,0.png",
	"res://game/pez/art/3,2,1,1.png",
	"res://game/pez/art/3,2,1,2.png",
	"res://game/pez/art/3,2,1,3.png",
]

var paths_level_3 := [
	"res://game/pez/art/0,3,0,0.png",
	"res://game/pez/art/0,3,0,1.png",
	"res://game/pez/art/0,3,0,2.png",
	"res://game/pez/art/0,3,0,3.png",
	"res://game/pez/art/0,3,1,0.png",
	"res://game/pez/art/0,3,1,1.png",
	"res://game/pez/art/0,3,1,2.png",
	"res://game/pez/art/0,3,1,3.png",
	"res://game/pez/art/1,3,0,0.png",
	"res://game/pez/art/1,3,0,1.png",
	"res://game/pez/art/1,3,0,2.png",
	"res://game/pez/art/1,3,0,3.png",
	"res://game/pez/art/1,3,1,0.png",
	"res://game/pez/art/1,3,1,1.png",
	"res://game/pez/art/1,3,1,2.png",
	"res://game/pez/art/1,3,1,3.png",
	"res://game/pez/art/2,3,0,0.png",
	"res://game/pez/art/2,3,0,1.png",
	"res://game/pez/art/2,3,0,2.png",
	"res://game/pez/art/2,3,0,3.png",
	"res://game/pez/art/2,3,1,0.png",
	"res://game/pez/art/2,3,1,1.png",
	"res://game/pez/art/2,3,1,2.png",
	"res://game/pez/art/2,3,1,3.png",
	"res://game/pez/art/3,3,0,0.png",
	"res://game/pez/art/3,3,0,1.png",
	"res://game/pez/art/3,3,0,2.png",
	"res://game/pez/art/3,3,0,3.png",
	"res://game/pez/art/3,3,1,0.png",
	"res://game/pez/art/3,3,1,1.png",
	"res://game/pez/art/3,3,1,2.png",
	"res://game/pez/art/3,3,1,3.png",
	"res://game/pez/art/4,0,0,0.png",
	"res://game/pez/art/4,0,0,1.png",
	"res://game/pez/art/4,0,0,2.png",
	"res://game/pez/art/4,0,0,3.png",
	"res://game/pez/art/4,0,1,0.png",
	"res://game/pez/art/4,0,1,1.png",
	"res://game/pez/art/4,0,1,2.png",
	"res://game/pez/art/4,0,1,3.png",
	"res://game/pez/art/4,1,0,0.png",
	"res://game/pez/art/4,1,0,1.png",
	"res://game/pez/art/4,1,0,2.png",
	"res://game/pez/art/4,1,0,3.png",
	"res://game/pez/art/4,1,1,0.png",
	"res://game/pez/art/4,1,1,1.png",
	"res://game/pez/art/4,1,1,2.png",
	"res://game/pez/art/4,1,1,3.png",
	"res://game/pez/art/4,2,0,0.png",
	"res://game/pez/art/4,2,0,1.png",
	"res://game/pez/art/4,2,0,2.png",
	"res://game/pez/art/4,2,0,3.png",
	"res://game/pez/art/4,2,1,0.png",
	"res://game/pez/art/4,2,1,1.png",
	"res://game/pez/art/4,2,1,2.png",
	"res://game/pez/art/4,2,1,3.png",
	"res://game/pez/art/4,3,0,0.png",
	"res://game/pez/art/4,3,0,1.png",
	"res://game/pez/art/4,3,0,2.png",
	"res://game/pez/art/4,3,0,3.png",
	"res://game/pez/art/4,3,1,0.png",
	"res://game/pez/art/4,3,1,1.png",
	"res://game/pez/art/4,3,1,2.png",
	"res://game/pez/art/4,3,1,3.png",
	"res://game/pez/art/5,0,0,0.png",
	"res://game/pez/art/5,0,0,1.png",
	"res://game/pez/art/5,0,0,2.png",
	"res://game/pez/art/5,0,0,3.png",
	"res://game/pez/art/5,0,1,0.png",
	"res://game/pez/art/5,0,1,1.png",
	"res://game/pez/art/5,0,1,2.png",
	"res://game/pez/art/5,0,1,3.png",
	"res://game/pez/art/5,1,0,0.png",
	"res://game/pez/art/5,1,0,1.png",
	"res://game/pez/art/5,1,0,2.png",
	"res://game/pez/art/5,1,0,3.png",
	"res://game/pez/art/5,1,1,0.png",
	"res://game/pez/art/5,1,1,1.png",
	"res://game/pez/art/5,1,1,2.png",
	"res://game/pez/art/5,1,1,3.png",
	"res://game/pez/art/5,2,0,0.png",
	"res://game/pez/art/5,2,0,1.png",
	"res://game/pez/art/5,2,0,2.png",
	"res://game/pez/art/5,2,0,3.png",
	"res://game/pez/art/5,2,1,0.png",
	"res://game/pez/art/5,2,1,1.png",
	"res://game/pez/art/5,2,1,2.png",
	"res://game/pez/art/5,2,1,3.png",
	"res://game/pez/art/5,3,0,0.png",
	"res://game/pez/art/5,3,0,1.png",
	"res://game/pez/art/5,3,0,2.png",
	"res://game/pez/art/5,3,0,3.png",
	"res://game/pez/art/5,3,1,0.png",
	"res://game/pez/art/5,3,1,1.png",
	"res://game/pez/art/5,3,1,2.png",
	"res://game/pez/art/5,3,1,3.png",
]
#endregion

var paths_levels = [paths_level_1, paths_level_2, paths_level_3]
var fish_sprites: Array[Array] = [[], [], []]


func _process(_delta: float) -> void:
	var all_loaded := true
	for level in paths_levels:
		for path in level:
			var status = ResourceLoader.load_threaded_get_status(path)
			if status != ResourceLoader.THREAD_LOAD_LOADED:
				all_loaded = false
				break

	if all_loaded:
		for i in range(paths_levels.size()):
			for path in paths_levels[i]:
				fish_sprites[i].append(ResourceLoader.load_threaded_get(path))


func load_fishes_in_background():
	for level in paths_levels:
		for path in level:
			ResourceLoader.load_threaded_request(path, "", true)


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


func reset_round() -> void:
	set_time(5)
	reset_fish(10)


func reset_score() -> void:
	score = 0

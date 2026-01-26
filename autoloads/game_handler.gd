extends Node

signal time_changed(value)
signal score_changed(value)
signal fishes_left_changed(value)
signal change_rules(value)
signal reset_fishes(value)

var time_left: float = 5
var score: int = 0
var fishes_left: int = 10
var rules: Array = []
var processable_rules: Array = []

#region Fish paths

var paths_level_1 := [
	"res://game/pez/art/fish types/0,0,0,0.png",
	"res://game/pez/art/fish types/0,0,0,1.png",
	"res://game/pez/art/fish types/0,0,0,2.png",
	"res://game/pez/art/fish types/0,1,0,0.png",
	"res://game/pez/art/fish types/0,1,0,1.png",
	"res://game/pez/art/fish types/0,1,0,2.png",
	"res://game/pez/art/fish types/1,0,0,0.png",
	"res://game/pez/art/fish types/1,0,0,1.png",
	"res://game/pez/art/fish types/1,0,0,2.png",
	"res://game/pez/art/fish types/1,1,0,0.png",
	"res://game/pez/art/fish types/1,1,0,1.png",
	"res://game/pez/art/fish types/1,1,0,2.png",
	"res://game/pez/art/fish types/2,0,0,0.png",
	"res://game/pez/art/fish types/2,0,0,1.png",
	"res://game/pez/art/fish types/2,0,0,2.png",
	"res://game/pez/art/fish types/2,1,0,0.png",
	"res://game/pez/art/fish types/2,1,0,1.png",
	"res://game/pez/art/fish types/2,1,0,2.png",
]

var paths_level_2 := [
	"res://game/pez/art/fish types/0,0,1,0.png",
	"res://game/pez/art/fish types/0,0,1,1.png",
	"res://game/pez/art/fish types/0,0,1,2.png",
	"res://game/pez/art/fish types/0,0,1,3.png",
	"res://game/pez/art/fish types/0,1,1,0.png",
	"res://game/pez/art/fish types/0,1,1,1.png",
	"res://game/pez/art/fish types/0,1,1,2.png",
	"res://game/pez/art/fish types/0,1,1,3.png",
	"res://game/pez/art/fish types/0,0,0,3.png",
	"res://game/pez/art/fish types/0,1,0,3.png",
	"res://game/pez/art/fish types/0,2,0,0.png",
	"res://game/pez/art/fish types/0,2,0,1.png",
	"res://game/pez/art/fish types/0,2,0,2.png",
	"res://game/pez/art/fish types/0,2,0,3.png",
	"res://game/pez/art/fish types/0,2,1,0.png",
	"res://game/pez/art/fish types/0,2,1,1.png",
	"res://game/pez/art/fish types/0,2,1,2.png",
	"res://game/pez/art/fish types/0,2,1,3.png",
	"res://game/pez/art/fish types/1,0,0,3.png",
	"res://game/pez/art/fish types/1,0,1,0.png",
	"res://game/pez/art/fish types/1,0,1,1.png",
	"res://game/pez/art/fish types/1,0,1,2.png",
	"res://game/pez/art/fish types/1,0,1,3.png",
	"res://game/pez/art/fish types/1,1,0,3.png",
	"res://game/pez/art/fish types/1,1,1,0.png",
	"res://game/pez/art/fish types/1,1,1,1.png",
	"res://game/pez/art/fish types/1,1,1,2.png",
	"res://game/pez/art/fish types/1,1,1,3.png",
	"res://game/pez/art/fish types/1,2,0,0.png",
	"res://game/pez/art/fish types/1,2,0,1.png",
	"res://game/pez/art/fish types/1,2,0,2.png",
	"res://game/pez/art/fish types/1,2,0,3.png",
	"res://game/pez/art/fish types/1,2,1,0.png",
	"res://game/pez/art/fish types/1,2,1,1.png",
	"res://game/pez/art/fish types/1,2,1,2.png",
	"res://game/pez/art/fish types/1,2,1,3.png",
	"res://game/pez/art/fish types/2,0,0,3.png",
	"res://game/pez/art/fish types/2,0,1,0.png",
	"res://game/pez/art/fish types/2,0,1,1.png",
	"res://game/pez/art/fish types/2,0,1,2.png",
	"res://game/pez/art/fish types/2,0,1,3.png",
	"res://game/pez/art/fish types/2,1,0,3.png",
	"res://game/pez/art/fish types/2,1,1,0.png",
	"res://game/pez/art/fish types/2,1,1,1.png",
	"res://game/pez/art/fish types/2,1,1,2.png",
	"res://game/pez/art/fish types/2,1,1,3.png",
	"res://game/pez/art/fish types/2,2,0,0.png",
	"res://game/pez/art/fish types/2,2,0,1.png",
	"res://game/pez/art/fish types/2,2,0,2.png",
	"res://game/pez/art/fish types/2,2,0,3.png",
	"res://game/pez/art/fish types/2,2,1,0.png",
	"res://game/pez/art/fish types/2,2,1,1.png",
	"res://game/pez/art/fish types/2,2,1,2.png",
	"res://game/pez/art/fish types/2,2,1,3.png",
	"res://game/pez/art/fish types/3,0,0,0.png",
	"res://game/pez/art/fish types/3,0,0,1.png",
	"res://game/pez/art/fish types/3,0,0,2.png",
	"res://game/pez/art/fish types/3,0,0,3.png",
	"res://game/pez/art/fish types/3,0,1,0.png",
	"res://game/pez/art/fish types/3,0,1,1.png",
	"res://game/pez/art/fish types/3,0,1,2.png",
	"res://game/pez/art/fish types/3,0,1,3.png",
	"res://game/pez/art/fish types/3,1,0,0.png",
	"res://game/pez/art/fish types/3,1,0,1.png",
	"res://game/pez/art/fish types/3,1,0,2.png",
	"res://game/pez/art/fish types/3,1,0,3.png",
	"res://game/pez/art/fish types/3,1,1,0.png",
	"res://game/pez/art/fish types/3,1,1,1.png",
	"res://game/pez/art/fish types/3,1,1,2.png",
	"res://game/pez/art/fish types/3,1,1,3.png",
	"res://game/pez/art/fish types/3,2,0,0.png",
	"res://game/pez/art/fish types/3,2,0,1.png",
	"res://game/pez/art/fish types/3,2,0,2.png",
	"res://game/pez/art/fish types/3,2,0,3.png",
	"res://game/pez/art/fish types/3,2,1,0.png",
	"res://game/pez/art/fish types/3,2,1,1.png",
	"res://game/pez/art/fish types/3,2,1,2.png",
	"res://game/pez/art/fish types/3,2,1,3.png",
]

var paths_level_3 := [
	"res://game/pez/art/fish types/0,3,0,0.png",
	"res://game/pez/art/fish types/0,3,0,1.png",
	"res://game/pez/art/fish types/0,3,0,2.png",
	"res://game/pez/art/fish types/0,3,0,3.png",
	"res://game/pez/art/fish types/0,3,1,0.png",
	"res://game/pez/art/fish types/0,3,1,1.png",
	"res://game/pez/art/fish types/0,3,1,2.png",
	"res://game/pez/art/fish types/0,3,1,3.png",
	"res://game/pez/art/fish types/1,3,0,0.png",
	"res://game/pez/art/fish types/1,3,0,1.png",
	"res://game/pez/art/fish types/1,3,0,2.png",
	"res://game/pez/art/fish types/1,3,0,3.png",
	"res://game/pez/art/fish types/1,3,1,0.png",
	"res://game/pez/art/fish types/1,3,1,1.png",
	"res://game/pez/art/fish types/1,3,1,2.png",
	"res://game/pez/art/fish types/1,3,1,3.png",
	"res://game/pez/art/fish types/2,3,0,0.png",
	"res://game/pez/art/fish types/2,3,0,1.png",
	"res://game/pez/art/fish types/2,3,0,2.png",
	"res://game/pez/art/fish types/2,3,0,3.png",
	"res://game/pez/art/fish types/2,3,1,0.png",
	"res://game/pez/art/fish types/2,3,1,1.png",
	"res://game/pez/art/fish types/2,3,1,2.png",
	"res://game/pez/art/fish types/2,3,1,3.png",
	"res://game/pez/art/fish types/3,3,0,0.png",
	"res://game/pez/art/fish types/3,3,0,1.png",
	"res://game/pez/art/fish types/3,3,0,2.png",
	"res://game/pez/art/fish types/3,3,0,3.png",
	"res://game/pez/art/fish types/3,3,1,0.png",
	"res://game/pez/art/fish types/3,3,1,1.png",
	"res://game/pez/art/fish types/3,3,1,2.png",
	"res://game/pez/art/fish types/3,3,1,3.png",
	"res://game/pez/art/fish types/4,0,0,0.png",
	"res://game/pez/art/fish types/4,0,0,1.png",
	"res://game/pez/art/fish types/4,0,0,2.png",
	"res://game/pez/art/fish types/4,0,0,3.png",
	"res://game/pez/art/fish types/4,0,1,0.png",
	"res://game/pez/art/fish types/4,0,1,1.png",
	"res://game/pez/art/fish types/4,0,1,2.png",
	"res://game/pez/art/fish types/4,0,1,3.png",
	"res://game/pez/art/fish types/4,1,0,0.png",
	"res://game/pez/art/fish types/4,1,0,1.png",
	"res://game/pez/art/fish types/4,1,0,2.png",
	"res://game/pez/art/fish types/4,1,0,3.png",
	"res://game/pez/art/fish types/4,1,1,0.png",
	"res://game/pez/art/fish types/4,1,1,1.png",
	"res://game/pez/art/fish types/4,1,1,2.png",
	"res://game/pez/art/fish types/4,1,1,3.png",
	"res://game/pez/art/fish types/4,2,0,0.png",
	"res://game/pez/art/fish types/4,2,0,1.png",
	"res://game/pez/art/fish types/4,2,0,2.png",
	"res://game/pez/art/fish types/4,2,0,3.png",
	"res://game/pez/art/fish types/4,2,1,0.png",
	"res://game/pez/art/fish types/4,2,1,1.png",
	"res://game/pez/art/fish types/4,2,1,2.png",
	"res://game/pez/art/fish types/4,2,1,3.png",
	"res://game/pez/art/fish types/4,3,0,0.png",
	"res://game/pez/art/fish types/4,3,0,1.png",
	"res://game/pez/art/fish types/4,3,0,2.png",
	"res://game/pez/art/fish types/4,3,0,3.png",
	"res://game/pez/art/fish types/4,3,1,0.png",
	"res://game/pez/art/fish types/4,3,1,1.png",
	"res://game/pez/art/fish types/4,3,1,2.png",
	"res://game/pez/art/fish types/4,3,1,3.png",
	"res://game/pez/art/fish types/5,0,0,0.png",
	"res://game/pez/art/fish types/5,0,0,1.png",
	"res://game/pez/art/fish types/5,0,0,2.png",
	"res://game/pez/art/fish types/5,0,0,3.png",
	"res://game/pez/art/fish types/5,0,1,0.png",
	"res://game/pez/art/fish types/5,0,1,1.png",
	"res://game/pez/art/fish types/5,0,1,2.png",
	"res://game/pez/art/fish types/5,0,1,3.png",
	"res://game/pez/art/fish types/5,1,0,0.png",
	"res://game/pez/art/fish types/5,1,0,1.png",
	"res://game/pez/art/fish types/5,1,0,2.png",
	"res://game/pez/art/fish types/5,1,0,3.png",
	"res://game/pez/art/fish types/5,1,1,0.png",
	"res://game/pez/art/fish types/5,1,1,1.png",
	"res://game/pez/art/fish types/5,1,1,2.png",
	"res://game/pez/art/fish types/5,1,1,3.png",
	"res://game/pez/art/fish types/5,2,0,0.png",
	"res://game/pez/art/fish types/5,2,0,1.png",
	"res://game/pez/art/fish types/5,2,0,2.png",
	"res://game/pez/art/fish types/5,2,0,3.png",
	"res://game/pez/art/fish types/5,2,1,0.png",
	"res://game/pez/art/fish types/5,2,1,1.png",
	"res://game/pez/art/fish types/5,2,1,2.png",
	"res://game/pez/art/fish types/5,2,1,3.png",
	"res://game/pez/art/fish types/5,3,0,0.png",
	"res://game/pez/art/fish types/5,3,0,1.png",
	"res://game/pez/art/fish types/5,3,0,2.png",
	"res://game/pez/art/fish types/5,3,0,3.png",
	"res://game/pez/art/fish types/5,3,1,0.png",
	"res://game/pez/art/fish types/5,3,1,1.png",
	"res://game/pez/art/fish types/5,3,1,2.png",
	"res://game/pez/art/fish types/5,3,1,3.png",
]
#endregion

var paths_levels = [paths_level_1, paths_level_2, paths_level_3]
var fish_sprites: Array[Array] = [[], [], []]

var check_finished := false
var fish_loaded := false

var level_idx := 0
var path_idx := 0

var level_requested := false
var level_loaded_count := 0
var request_idx := 0
var requesting_level := false
var level: int = 0


func _process(_delta: float) -> void:
	if fish_loaded:
		return

	var level_paths: Array = paths_levels[level_idx]

	# 1️⃣ Fase de REQUEST (1 por frame)
	if not requesting_level:
		var fish_path: String = level_paths[request_idx]
		ResourceLoader.load_threaded_request(fish_path, "", true)

		request_idx += 1
		if request_idx >= level_paths.size():
			requesting_level = true
			request_idx = 0
			path_idx = 0
			level_loaded_count = 0
			#print("Level ", level_idx, " requests queued")

		return

	# 2️⃣ Fase de POLLING + CONSUMO (1 por frame)
	var path: String = level_paths[path_idx]
	var status := ResourceLoader.load_threaded_get_status(path)

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		fish_sprites[level_idx].append(
			ResourceLoader.load_threaded_get(path)
		)
		level_loaded_count += 1

	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		push_error("Failed to load: " + path)
		level_loaded_count += 1

	path_idx += 1
	if path_idx >= level_paths.size():
		path_idx = 0

	# 3️⃣ ¿Nivel terminado?
	if level_loaded_count >= level_paths.size():
		print("Level ", level_idx, " fish loaded")

		level_idx += 1
		requesting_level = false
		request_idx = 0

		if level_idx >= paths_levels.size():
			fish_loaded = true
			set_process(false)
			print("All fish loaded")


func set_processable_rules(values: Array):
	processable_rules = values


func get_processable_rules() -> Array:
	return processable_rules


func get_current_rules() -> Array:
	return rules


func start_next_set(value: Array):
	rules = value
	#print("Rules recibidas: ", rules)
	change_rules.emit(rules)


func set_time(value: float):
	time_left = value
	time_changed.emit(time_left)


func get_time() -> float:
	return time_left


func add_score(value: int):
	score += value
	score_changed.emit(score, value)


func set_fishes_left(value: int):
	fishes_left = value
	fishes_left_changed.emit(fishes_left)


func reset_fish(value: int):
	fishes_left = value
	reset_fishes.emit(fishes_left)


func reset_round() -> void:
	set_time(5)
	reset_fish(10)


func reset_score() -> void:
	score = 0
	level = 0

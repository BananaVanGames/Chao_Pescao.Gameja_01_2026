extends Node

signal time_changed(value)
signal score_changed(value)
signal fishes_left_changed(value)
signal change_rules(value)
signal reset_fishes(value)
signal update_hearts(value)
signal update_max_life(value)
signal transition_finished
signal rules_error(value)

const NIVEL_TUTORIAL: int = 0

var max_life_points: int = 5
var life_points: int = max_life_points
var lost_life: int = -1

var time_left: float = 5
var score: int = 0
var level: int = 0
var start_time: float = 0

var fishes_left: int = 10
var rules: Array = []
var processable_rules: Array = []

# PECES PELIGROSOS: 
var reglas_procesables1: Array = [[1], [0, 1], [0, 1, 2]]
var reglas_procesables2: Array = [[2, 3, 4], [0, 1, 2], [0, 1, 2, 3]]
var reglas_procesables3: Array = [[2, 3, 4, 5], [1, 2, 3], [0, 1, 2, 3]]
var reglas_procesables: Array = [reglas_procesables1, reglas_procesables2, reglas_procesables3]

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

var paths_levels = [paths_level_1, paths_level_2, paths_level_3]
var fish_sprites: Array[Array] = [[], [], []]

var check_finished := false
var fish_loaded := false
var level_idx := 0
var path_idx := 0
var request_idx := 0
var level_loaded_count := 0
var requesting_level := false

var transition: Transition

#endregion

@onready var game_music: AudioStream = preload("res://music/InGame1.mp3")
@onready var transition_layer = preload("uid://bd83eekpbqxx2")


func _ready() -> void:
	transition = transition_layer.instantiate()
	add_child(transition)
	transition.transition_finished.connect(_on_transition_finished)


func _process(_delta: float) -> void:
	if fish_loaded:
		return

	var level_paths: Array = paths_levels[level_idx]

	if not requesting_level:
		var fish_path: String = level_paths[request_idx]
		ResourceLoader.load_threaded_request(fish_path, "", true)

		request_idx += 1
		if request_idx >= level_paths.size():
			requesting_level = true
			request_idx = 0
			path_idx = 0
			level_loaded_count = 0

		return

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

	if level_loaded_count >= level_paths.size():
		#print("Level ", level_idx, " fish loaded")

		level_idx += 1
		requesting_level = false
		request_idx = 0

		if level_idx >= paths_levels.size():
			fish_loaded = true
			set_process(false)
			print("All fish loaded")


func trigger_rules_error(results: Array) -> void:
	rules_error.emit(results)


func get_life_points() -> int:
	return life_points


func get_score() -> int:
	return score


func lose_life_point() -> bool:
	life_points -= 1
	lost_life += 1
	print("PUNTOS DE VIDA:", life_points)

	var restore_life := false
	update_hearts.emit(life_points, restore_life)

	if life_points < 0:
		transition.play_game_finished(start_time)
		SettingsHandler.add_to_scoreboard(GameHandler.get_score(), GameHandler.get_level())
		GameHandler.reset_game()

		print("Game Over")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		return false
	return true


func get_lost_life() -> int:
	return lost_life


func add_life_point() -> void:
	if life_points < max_life_points:
		life_points += 1
		var restore_life := true
		update_hearts.emit(life_points - 1, restore_life)


func get_current_rules() -> Array:
	return rules


func randomize_rules():
	rules.clear()
	processable_rules.clear()

	for i in range(3):
		rules.append(reglas_procesables[min(level, 2)][i].pick_random())
		processable_rules.append(randi_range(0, 1))
	change_rules.emit(rules, processable_rules)


func set_processable_rules(values: Array):
	processable_rules = values


func get_processable_rules() -> Array:
	return processable_rules


func set_time(value: float):
	time_left = value
	time_changed.emit(time_left)


func get_time() -> float:
	return time_left


func game_over() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://ui/main_menu/main_menu.tscn")


func add_score(value: int) -> bool:
	score += value
	score_changed.emit(score, value)
	if value == -3 and level > NIVEL_TUTORIAL:
		return lose_life_point()
	return true


func set_fishes_left(value: int):
	fishes_left = value
	fishes_left_changed.emit(fishes_left)


func get_level() -> int:
	return level


func add_level() -> void:
	level += 1


func advance_next_level() -> void:
	add_level()
	reset_round()
	add_life_point()
	transition.play_between_rounds()
	print("LEVEL ACTUAL: ", level)

	match level:
		3:
			max_life_points = 3
		5:
			max_life_points = 1
		6:
			max_life_points = 0
	life_points = min(max_life_points, life_points)
	update_max_life.emit(max_life_points)


func get_max_life() -> int:
	return max_life_points


func reset_fish(value: int):
	fishes_left = value
	reset_fishes.emit(fishes_left)


func reset_round() -> void:
	set_time(5)
	reset_fish(10)


func reset_game() -> void:
	score = 0
	level = 0
	max_life_points = 5
	life_points = max_life_points
	lost_life = 0
	start_time = 0


func set_start_time(value: float) -> void:
	start_time = value


func _on_transition_finished() -> void:
	randomize_rules()
	transition_finished.emit()

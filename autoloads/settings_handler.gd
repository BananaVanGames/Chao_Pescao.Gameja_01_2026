extends Node

const SAVE_PATH = "user://scores.save"
const MAX_SCORES = 10

var scores = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_scores()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_score(new_score: int) -> void:
	var date = Time.get_datetime_string_from_system().split("T")[0]

	scores.append({
		"score": new_score,
		"date": date
		})

	scores.sort_custom(func(a, b): return a["score"] > b["score"])

	if scores.size() > MAX_SCORES:
		scores.resize(MAX_SCORES)

	save_scores()


func save_scores() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(scores)


func load_scores() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		scores = file.get_var()

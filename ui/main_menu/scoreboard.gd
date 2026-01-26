extends VBoxContainer

var row_scene = preload("res://ui/main_menu/score_row.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_scoreboard()

func populate_scoreboard():
	# Remove old rows (keep title if you want)
	for child in get_children():
		if child.name != "Scoreboard":
			child.queue_free()

	var scores = SettingsHandler.scores

	for i in scores.size():
		var row = row_scene.instantiate()
		add_child(row)

		row.get_node("HBoxContainer/Position").text = str(i + 1)
		row.get_node("HBoxContainer/Score").text = str(scores[i]["score"])
		row.get_node("HBoxContainer/Date").text = scores[i]["date"]

		if i < 3:
			row.modulate = Color(1, 0.9, 0.4)

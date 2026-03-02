extends VBoxContainer

var row_scene = preload("res://ui/main_menu/score_row.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_scoreboard()


func populate_scoreboard():
	SettingsHandler.load_scores()
	var scores = SettingsHandler.scores

	for i in range(scores.size()):
		var row = row_scene.instantiate()
		add_child(row)

		row.get_node("HBoxContainer/Position").text = str(i + 1)
		row.get_node("HBoxContainer/Score").text = str(scores[i].get("score", 0))
		row.get_node("HBoxContainer/Level").text = str(scores[i].get("level", 0))
		row.get_node("HBoxContainer/Date").text = scores[i].get("date", 0)

		match i:
			0:
				row.modulate = Color("GOLD")
			1:
				row.modulate = Color("SILVER")
			2:
				row.modulate = Color("CHOCOLATE")

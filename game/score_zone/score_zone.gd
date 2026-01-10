extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_good_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	var fish_data = body.get_fish_data()
	print("FISH DATA: ", fish_data)
	body.queue_free()


func _on_bad_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	var fish_data = body.get_fish_data()
	print("FISH DATA: ", fish_data)
	print("Current Rules: ", GameHandler.get_current_rules())
	print("Current Danger Rules: ", GameHandler.get_danger_rules())

	body.queue_free()

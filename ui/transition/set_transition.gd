extends CanvasLayer

signal transition_finished

@onready var mask: Sprite2D = $FishMask

func play():
	# Show the CanvasLayer (and fish)
	visible = true


	# Wait a short moment so the player sees it (optional)
	await get_tree().create_timer(1).timeout

	# Hide the CanvasLayer again
	visible = false
	transition_finished.emit()

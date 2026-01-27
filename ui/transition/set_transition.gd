extends CanvasLayer

signal transition_finished

@onready var mask: Sprite2D = $FishMask
@onready var label: Label = $Label


func play(time: float = 1, text: String = "MAS PESCAOS A CLASIFICAR!"):
	label.text = text
	
	visible = true
	await get_tree().create_timer(time).timeout

	visible = false
	transition_finished.emit()

extends CanvasLayer

signal transition_finished

@onready var mask: Sprite2D = $FishMask

func play():
	visible = true
	mask.scale = Vector2.ZERO

	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	tween.tween_property(mask, "scale", Vector2(30, 30), 0.4)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(mask, "scale", Vector2.ZERO, 0.4)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(func():
		visible = false
		emit_signal("transition_finished")
	)

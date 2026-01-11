extends CanvasLayer

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	audio_stream_player.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if get_tree().paused:
			visible = false
			get_tree().paused = false
			audio_stream_player.stop()
		else:
			visible = true
			get_tree().paused = true
			audio_stream_player.play()

func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	audio_stream_player.stop()
	

func _on_main_menu_pressed() -> void:
	confirmation_dialog.popup_centered()


func _on_confirmation_dialog_confirmed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

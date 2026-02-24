class_name Pause_Menu
extends CanvasLayer

@export var in_tutorial: bool = false

var game_music_pos: float = 0

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var tutorial_scene: PackedScene = preload("res://ui/tutorial/tutorial.tscn")
@onready var pause_music: AudioStream = preload("res://music/pausa.mp3")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and not in_tutorial:
		toggle_pause()


func toggle_pause():
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		visible = false
		get_tree().paused = false
		MusicHandler.load_track(GameHandler.game_music)
		MusicHandler.play(game_music_pos)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		visible = true
		get_tree().paused = true
		game_music_pos = MusicHandler.get_playback_position()
		MusicHandler.load_track(pause_music)
		MusicHandler.play()


func _on_main_menu_pressed() -> void:
	confirmation_dialog.popup_centered()


func _on_confirmation_dialog_confirmed() -> void:
	visible = false
	GameHandler.reset_game()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")


func _on_resume_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	visible = false
	get_tree().paused = false
	MusicHandler.load_track(GameHandler.game_music)
	MusicHandler.play(game_music_pos)


func _on_tutorial_finished() -> void:
	in_tutorial = false
	v_box_container.visible = true


func _on_tutorial_pressed() -> void:
	in_tutorial = true
	v_box_container.visible = false
	var pop_up_tutorial: Tutorial = tutorial_scene.instantiate()
	add_child(pop_up_tutorial)
	pop_up_tutorial.tutorial_finished.connect(_on_tutorial_finished)
	#pop_up_tutorial.executed_from_pause_menu()

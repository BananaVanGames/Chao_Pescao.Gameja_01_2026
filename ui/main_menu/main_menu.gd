extends Control

@onready var tutorial: Label = $VBoxContainer/Tutorial/Tutorial
@onready var tutorial_scene: PackedScene = preload("res://ui/tutorial/tutorial.tscn")
@onready var menu_music: AudioStream = preload("res://music/menu.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicHandler.load_track(menu_music)
	MusicHandler.play()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_tutorial_pressed() -> void:
	var pop_up_tutorial = tutorial_scene.instantiate()
	add_child(pop_up_tutorial)

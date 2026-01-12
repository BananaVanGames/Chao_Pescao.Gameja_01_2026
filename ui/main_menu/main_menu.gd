extends Control

@onready var tutorial: Label = $VBoxContainer/Tutorial/Tutorial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameHandler.load_fishes_in_background()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_tutorial_pressed() -> void:
	if tutorial.visible == true:
		tutorial.visible = false
	else:
		tutorial.visible = true

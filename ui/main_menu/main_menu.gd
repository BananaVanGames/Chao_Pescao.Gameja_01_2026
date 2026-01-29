extends Control

var nav_stack: Array[Control] = []
var current_panel

@onready var tutorial_scene: PackedScene = preload("res://ui/tutorial/tutorial.tscn")

@onready var menu: VBoxContainer = $Menu
@onready var settings_button: TextureButton = $Menu/Settings
@onready var scoreboard_button: TextureButton = $Menu/Scoreboard
@onready var back_button: TextureButton = $Back

@onready var settings: VBoxContainer = $Settings
@onready var scoreboard: VBoxContainer = $Scoreboard

@onready var menu_music: AudioStream = load("res://music/menu.mp3")
@onready var title: TextureRect = $Title
@onready var gameja_logo: TextureRect = $GamejaLogo
@onready var banana_logo: TextureRect = $BananaLogo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicHandler.load_track(menu_music)
	MusicHandler.play()

	current_panel = menu
	_show_panel(menu)
	_update_back_button()

	settings_button.pressed.connect(_navigate_to.bind(settings))
	scoreboard_button.pressed.connect(_navigate_to.bind(scoreboard))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _show_panel(panel: Control):
	panel.visible = true
	if panel == menu:
		title.visible = true
		gameja_logo.visible = true
		banana_logo.visible = true


func _update_back_button():
	back_button.visible = nav_stack.size() > 0


func _navigate_to(panel: Control):
	if current_panel:
		nav_stack.append(current_panel)
		current_panel.visible = false
		title.visible = false
		gameja_logo.visible = false
		banana_logo.visible = false

	current_panel = panel
	_show_panel(current_panel)
	_update_back_button()


func _on_back_pressed():
	if nav_stack.is_empty():
		return

	current_panel.visible = false
	current_panel = nav_stack.pop_back()
	_show_panel(current_panel)
	_update_back_button()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_tutorial_pressed() -> void:
	var pop_up_tutorial: Tutorial = tutorial_scene.instantiate()
	add_child(pop_up_tutorial)

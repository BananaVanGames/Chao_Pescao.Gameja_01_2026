extends TextureButton

const HUH = preload("uid://i77re6d8vq5a")
const GEMIDO = preload("uid://u816aegx3aq5")

@export var label_text: String:
	set(value):
		label_text = value

var hovered_button: TextureButton = null

@onready var fish_button: TextureButton = $"."
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var label: Label = $Label


func _ready() -> void:
	label.text = label_text
	fish_button.mouse_entered.connect(_on_mouse_entered.bind(fish_button))
	fish_button.mouse_exited.connect(_on_mouse_exited.bind(fish_button))


func _on_mouse_entered(button: TextureButton) -> void:
	hovered_button = button
	sfx_player.stream = HUH
	sfx_player.play()


func _on_mouse_exited(button: TextureButton) -> void:
	if hovered_button == button:
		hovered_button = null


func _on_button_down() -> void:
	sfx_player.stream = GEMIDO
	sfx_player.play()

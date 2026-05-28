class_name Transition
extends CanvasLayer

signal transition_finished

const SCORE_MESSAGES := [
	{ "min": -INF, "max": -45, "msg": "AGÁRRENLE! OTRO PEZ MÁS A PROCESAR" } ,
	{ "min": -44, "max": 0, "msg": "CHAO EMPLEAO!!" } ,
	{ "min": 0, "max": 89, "msg": "TRABAJA CORRECTAMENTE" } ,
	{ "min": 90, "max": 149, "msg": "MAGNÍFICO TRABAJO!... TU NOMBRE?" } ,
	{ "min": 150, "max": 249, "msg": "EMPLEADO/A DEL MES" } ,
	{ "min": 250, "max": INF, "msg": "NUEVO CEO DE CHAO PESCAO S.A." } ,
]

var hovered_button = null
var time: float = 0.0

@onready var back: TextureButton = $Back

@onready var mask: Sprite2D = $FishMask
@onready var label: Label = $Label
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	visible = false
	back.mouse_entered.connect(_mouse_entered.bind(back))
	back.mouse_exited.connect(_mouse_exited.bind(back))


func _process(delta: float) -> void:
	if hovered_button:
		time += delta
		var pulse = 1.0 + sin(time * 4.0) * 0.1
		hovered_button.scale = Vector2(pulse, pulse)
	else:
		time = 0.0


func get_score_message(score: int) -> String:
	for entry in SCORE_MESSAGES:
		if score >= entry.min and score <= entry.max:
			return entry.msg
	return ""


func play_between_rounds(time: float = 1, text: String = "COMIENZA EL SIGUIENTE TURNO!"):
	label.text = text
	visible = true

	animated_sprite_2d.play("transition-in")
	await animated_sprite_2d.animation_finished
	label.visible = true
	await get_tree().create_timer(time).timeout
	label.visible = false
	animated_sprite_2d.play("transition-out")
	await animated_sprite_2d.animation_finished

	finish_transition()


func finish_transition():
	visible = false
	transition_finished.emit()


func play_game_finished(start_time: float):
	animated_sprite_2d.play("transition-in")

	var resultados: String = ""
	resultados += get_score_message(GameHandler.get_score()) + "\n\n"
	resultados += "TIEMPO: " + str(snapped(Time.get_unix_time_from_system() - start_time, 0.01)) + "s\n"
	resultados += "PUNTUACIÓN: " + str(GameHandler.get_score()) + "\n"
	resultados += "NIVEL ALCANZADO: " + str(GameHandler.get_level() + 1) + "\n"
	resultados += "VIDAS PERDIDAS: " + str(GameHandler.get_lost_life()) + "\n"
	label.text = resultados

	visible = true
	await animated_sprite_2d.animation_finished

	label.visible = true
	back.visible = true


func _mouse_entered(button) -> void:
	hovered_button = button


func _mouse_exited(button) -> void:
	if hovered_button == button:
		hovered_button.scale = Vector2.ONE
		hovered_button = null


func _on_back_pressed() -> void:
	back.visible = false
	visible = false
	GameHandler.game_over()
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://ui/main_menu/main_menu.tscn")

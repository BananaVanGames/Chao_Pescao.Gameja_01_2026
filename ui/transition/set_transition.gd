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

@onready var mask: Sprite2D = $FishMask
@onready var label: Label = $Label
@onready var aceptar: TextureButton = $Aceptar


func finish_transition():
	visible = false
	transition_finished.emit()


func get_score_message(score: int) -> String:
	for entry in SCORE_MESSAGES:
		if score >= entry.min and score <= entry.max:
			return entry.msg
	return ""


func play_between_rounds(time: float = 1, text: String = "MAS PESCAOS A CLASIFICAR!"):
	label.text = text

	visible = true
	await get_tree().create_timer(time).timeout

	finish_transition()


func play_game_finished(start_time: float):
	var resultados: String = ""
	resultados += get_score_message(GameHandler.get_score()) + "\n\n"
	resultados += "TIEMPO DE PARTIDA: " + str(snapped(Time.get_unix_time_from_system() - start_time, 0.01)) + "s\n"
	resultados += "PUNTUACIÓN: " + str(GameHandler.get_score()) + "\n"
	resultados += "NIVEL ALCANZADO: " + str(GameHandler.get_level() + 1) + "\n"
	resultados += "VIDAS PERDIDAS: " + str(GameHandler.get_lost_life()) + "\n"
	label.text = resultados

	visible = true
	aceptar.visible = true


func _on_aceptar_pressed() -> void:
	aceptar.visible = false
	visible = false
	GameHandler.game_over()
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://ui/main_menu/main_menu.tscn")

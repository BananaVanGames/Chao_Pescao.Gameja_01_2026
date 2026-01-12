extends CanvasLayer

var tutorial_running := false

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var musica_fondo: AudioStreamPlayer = $MusicaFondo
@onready var v_box_container: VBoxContainer = $VBoxContainer

@onready var dialogos: AudioStreamPlayer = $Dialogos
@onready var lo1_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/L01.wav")
@onready var po2_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/P02.wav")
@onready var se3_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/Se03.wav")
@onready var ao4_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/A04.wav")
@onready var eo5_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/E05.wav")
@onready var sa6_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/Sa06.wav")
@onready var sa7_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/Se07.ogg")
@onready var l_01: Sprite2D = $L01
@onready var l_02: Sprite2D = $L02
@onready var se_3: Sprite2D = $Se3
@onready var a_04: Sprite2D = $A04
@onready var e_05: Sprite2D = $E05
@onready var sa_06: Sprite2D = $Sa06
@onready var se_07: Sprite2D = $Se07

@onready var dialogue_list = [[lo1_dialogo, po2_dialogo, se3_dialogo, ao4_dialogo, eo5_dialogo, sa7_dialogo, sa6_dialogo], [l_01, l_02, se_3, a_04, e_05, se_07, sa_06]]
@onready var tutorial: ConfirmationDialog = $Tutorial


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	musica_fondo.stop()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if tutorial_running:
			tutorial.popup_centered()
		else:
			toggle_pause()


func toggle_pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if get_tree().paused:
		visible = false
		get_tree().paused = false
		musica_fondo.stop()
	else:
		dialogos.stream = lo1_dialogo
		l_01.visible = true
		dialogos.play()
		visible = true
		get_tree().paused = true
		musica_fondo.play()


func _on_main_menu_pressed() -> void:
	confirmation_dialog.popup_centered()


func _on_confirmation_dialog_confirmed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")


func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false
	musica_fondo.stop()


func _on_tutorial_pressed() -> void:
	tutorial_running = true
	v_box_container.visible = false
	for i in range(1, 7):
		dialogue_list[1][i].visible = true
		dialogos.stream = dialogue_list[0][i]
		dialogos.play()
		await dialogos.finished
		await get_tree().create_timer(0.5).timeout

	for i in range(7):
		dialogue_list[1][i].visible = false

	v_box_container.visible = true
	tutorial_running = false


func _on_tutorial_confirmed() -> void:
	dialogos.stop()
	for i in range(7):
		dialogue_list[1][i].visible = false

	v_box_container.visible = true
	tutorial_running = false

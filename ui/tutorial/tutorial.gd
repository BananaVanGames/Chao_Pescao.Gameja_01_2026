extends Control

signal tutorial_finished

var time_stamp: float = 0
var current_sprite: int = 0
var confirm_exit: bool = false

@onready var lo1_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/L01.wav")
@onready var po2_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/P02.wav")
@onready var se3_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/Se03.wav")
@onready var ao4_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/A04.wav")
@onready var eo5_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/E05.wav")
@onready var sa6_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/Sa06.wav")
@onready var sa7_dialogo: AudioStream = preload("res://ui/tutorial/dialogos/Se07.ogg")
@onready var l_01: TextureRect = $L01
@onready var l_02: TextureRect = $L02
@onready var se_3: TextureRect = $Se3
@onready var a_04: TextureRect = $A04
@onready var e_05: TextureRect = $E05
@onready var sa_06: TextureRect = $Sa06
@onready var se_07: TextureRect = $Se07
@onready var dialogos: AudioStreamPlayer = $Dialogos

@onready var dialogue_list = [[lo1_dialogo, po2_dialogo, se3_dialogo, ao4_dialogo, eo5_dialogo, sa6_dialogo, sa7_dialogo], [l_01, l_02, se_3, a_04, e_05, sa_06, se_07]]
@onready var fish_sprites = [l_01, l_02, se_3, a_04, e_05, sa_06, se_07]
@onready var confirm_quit_tutorial: ConfirmationDialog = $ConfirmQuitTutorial


func _ready() -> void:
	reset_tutorial()
	MusicHandler.stop()
	
	for i in range(7):
		current_sprite = i
		dialogue_list[1][i].visible = true
		dialogos.stream = dialogue_list[0][i]
		dialogos.play()
		await dialogos.finished
		await get_tree().create_timer(0.5).timeout

	finish_tutorial()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if not confirm_exit:
			confirm_exit = true
			time_stamp = dialogos.get_playback_position()
			dialogos.stop()
			confirm_quit_tutorial.popup_centered()
		else:
			confirm_exit = false



func finish_tutorial() -> void:
	emit_signal("tutorial_finished")
	MusicHandler.play()
	queue_free()


func reset_tutorial():
	time_stamp = 0
	for i in range(7):
		fish_sprites[i].visible = false


func _on_tutorial_confirmed() -> void:
	finish_tutorial()


func _on_tutorial_canceled() -> void:
	dialogos.play(time_stamp)

class_name Tutorial
extends Control

signal tutorial_finished

#region preload
const ADRIA_01 = preload("uid://byybuh0eejnwd")
const ADRIA_02 = preload("uid://cnqwbhmvy42dy")
const ADRIA_03 = preload("uid://bof47a1krb0yj")
const ADRIA_04 = preload("uid://bk6hho6te2ubs")
const ADRIA_05 = preload("uid://3srexa6ammer")
const ADRIA_06 = preload("uid://bajix36inhesa")
const ADRIA = [
	ADRIA_01,
	ADRIA_02,
	ADRIA_03,
	ADRIA_04,
	ADRIA_05,
	ADRIA_06,
]
const ELORA_01 = preload("uid://dxcs1q7taohp5")
const ELORA_02 = preload("uid://cpyp4vms7pj7n")
const ELORA_03 = preload("uid://6dnua3v7nxap")
const ELORA_04 = preload("uid://c45pqb20vffgk")
const ELORA_05 = preload("uid://djwxdp6g0bryj")
const ELORA = [
	ELORA_01,
	ELORA_02,
	ELORA_03,
	ELORA_04,
	ELORA_05,
]
const LUISMA_01 = preload("uid://crarfrtxou8ny")
const LUISMA_02 = preload("uid://dlwyewvmfq8wg")
const LUISMA_03 = preload("uid://6lskfl2od2f")
const LUISMA_04 = preload("uid://b0kquc2wtk11w")
const LUISMA_05 = preload("uid://drnl6teopkrro")
const LUISMA = [
	LUISMA_01,
	LUISMA_02,
	LUISMA_03,
	LUISMA_04,
	LUISMA_05,
]
const PAU_01 = preload("uid://chamruj26djwq")
const PAU_02 = preload("uid://byhtv6sg488i6")
const PAU_03 = preload("uid://crnbc5n1afs8a")
const PAU_04 = preload("uid://c68og0o1x5hlt")
const PAU = [
	PAU_01,
	PAU_02,
	PAU_03,
	PAU_04,
]
const SARA_01 = preload("uid://b7ju63t313eb2")
const SARA_02 = preload("uid://cbwcsfswfs4rn")
const SARA_03 = preload("uid://cawyqbv5e8xmi")
const SARA_04 = preload("uid://bx03enplf0rit")
const SARA_05 = preload("uid://cvlp0hyhp677d")
const SARA = [
	SARA_01,
	SARA_02,
	SARA_03,
	SARA_04,
	SARA_05,
]
const SERGI_01 = preload("uid://12bqjin5ri6k")
const SERGI_02 = preload("uid://db7mi1tpgsd6w")
const SERGI_03 = preload("uid://2qbbswksnp7s")
const SERGI_04 = preload("uid://1ae8estrl13q")
const SERGI_05 = preload("uid://dlrc1p1fnbcsl")
const SERGI = [
	SERGI_01,
	SERGI_02,
	SERGI_03,
	SERGI_04,
	SERGI_05,
]
const VICTOR_01 = preload("uid://hs584n67j6s8")
const VICTOR_02 = preload("uid://elf1jrf1vixk")
const VICTOR_03 = preload("uid://gfjiph8oh6dp")
const VICTOR_04 = preload("uid://b13w83xrhjtlf")
const VICTOR_05 = preload("uid://pny3lxm6ka4o")
const VICTOR_06 = preload("uid://cu02o2ykn4cs0")
const VICTOR = [
	VICTOR_01,
	VICTOR_02,
	VICTOR_03,
	VICTOR_04,
	VICTOR_05,
	VICTOR_06,
]

const VOCES = [LUISMA, SERGI, ELORA, SARA, ADRIA, PAU, VICTOR]

#endregion

var time_stamp: float = 0
var tutorial_idx: int = 0
var confirm_exit: bool = false
var especetro_audio: AudioEffectInstance = null
var i: int = 0
var j: int = 0

@onready var pez_1: TextureRect = $PEZ1
@onready var pez_2: TextureRect = $PEZ2
@onready var pez_3: TextureRect = $PEZ3 
@onready var pez_4: TextureRect = $PEZ4
@onready var pez_5: TextureRect = $SkewerPez5/PEZ5
@onready var pez_6: TextureRect = $PEZ6
@onready var pez_7: TextureRect = $PEZ7
@onready var tutorial_fish = [pez_1, pez_2, pez_3, pez_4, pez_5, pez_6, pez_7]

@onready var audio_player: AudioStreamPlayer = $Dialogos

@onready var confirm_quit_tutorial: ConfirmationDialog = $ConfirmQuitTutorial
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	especetro_audio = AudioServer.get_bus_effect_instance(3, 0)
	reset_tutorial()
	MusicHandler.stop()

	#start_tutorial()


func _process(_delta: float) -> void:
	var dB_level = especetro_audio.get_magnitude_for_frequency_range(0, 10000).length()
	if dB_level > 0.075:
		if not animation_player.is_playing():
			animation_player.play(str(i + 1) + "_talk")

	handle_dialogues()

	if Input.is_action_just_pressed("ui_cancel"):
		if not confirm_exit:
			confirm_exit = true
			time_stamp = audio_player.get_playback_position()
			audio_player.stop()
			confirm_quit_tutorial.popup_centered()
		else:
			confirm_exit = false


func handle_dialogues():
	if not audio_player.is_playing() and not confirm_exit:
		tutorial_fish[i].visible = true
		tutorial_fish[i - 1].visible = false
		audio_player.stream = VOCES[i][j]
		audio_player.play()

		j += 1
		if j >= VOCES[i].size():
			j = 0
			i += 1
			if i >= VOCES.size():
				i = 0


#func start_tutorial():
	#for i in VOCES.size():
		#tutorial_fish[i].visible = true
		#tutorial_idx = i + 1
		#for j in VOCES[i].size():
			#fish_talking = true
#
			#audio_player.stream = VOCES[i][j]
			#audio_player.play()
#
			#await audio_player.finished
			#fish_talking = false
			#await get_tree().create_timer(0.5).timeout
		#tutorial_fish[i].visible = false
	#finish_tutorial()


func finish_tutorial() -> void:
	tutorial_finished.emit()
	MusicHandler.play()
	get_tree().change_scene_to_file("uid://4xe8awboiffn")


func reset_tutorial():
	time_stamp = 0
	for fish in tutorial_fish:
		fish.visible = false


func _on_tutorial_confirmed() -> void:
	finish_tutorial()


func _on_tutorial_canceled() -> void:
	audio_player.play(time_stamp)

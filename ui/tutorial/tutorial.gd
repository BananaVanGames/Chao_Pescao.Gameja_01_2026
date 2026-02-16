class_name Tutorial
extends Control

signal tutorial_finished

#region preload dialogues
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
const SERGI_06 = preload("uid://c5bgepdpvpg13")
const SERGI = [
	SERGI_01,
	SERGI_02,
	SERGI_03,
	SERGI_04,
	SERGI_05,
	SERGI_06,
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

const PAU_CHAO_PESCAO = preload("uid://cb8wrc47jik7g")
const ADRIA_CHAO_PESCAO = preload("uid://bjx4wxpqhdkm2")
const ELORA_CHAO_PESCAO = preload("uid://ffp68i4bi3xl")
const LUISMA_CHAO_PESCAO = preload("uid://c00vf68t8va1u")
const SARA_CHAO_PESCAO = preload("uid://bwi112lnqhy5r")
const SERGI_CHAO_PESCAO = preload("uid://d20aoi8e63a38")
const VICTOR_CHAO_PESCAO = preload("uid://e0jqrh5mervp")
const CHAO_PESCAO = [
	PAU_CHAO_PESCAO,
	ADRIA_CHAO_PESCAO,
	ELORA_CHAO_PESCAO,
	LUISMA_CHAO_PESCAO,
	SARA_CHAO_PESCAO,
	SERGI_CHAO_PESCAO,
	VICTOR_CHAO_PESCAO,
]
#endregion

var time_stamp: float = 0
var current_sprite: int = 0
var confirm_exit: bool = false

@onready var l_01: TextureRect = $L01
@onready var l_02: TextureRect = $L02
@onready var se_3: TextureRect = $Se3
@onready var a_04: TextureRect = $A04
@onready var e_05: TextureRect = $E05
@onready var sa_06: TextureRect = $Sa06
@onready var se_07: TextureRect = $Se07
@onready var dialogos: AudioStreamPlayer = $Dialogos

@onready var fish_sprites = [l_01, l_02, se_3, a_04, e_05, sa_06, se_07]
@onready var confirm_quit_tutorial: ConfirmationDialog = $ConfirmQuitTutorial


func _ready() -> void:
	reset_tutorial()
	MusicHandler.stop()

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
	tutorial_finished.emit()
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

class_name Tutorial
extends Control

signal tutorial_finished

#region preload
const ADRIA_01 = preload("uid://byybuh0eejnwd")
const ADRIA_02 = preload("uid://cnqwbhmvy42dy")
const ADRIA_03 = preload("uid://bof47a1krb0yj")
const ADRIA_04 = preload("uid://bk6hho6te2ubs")
const ADRIA_05 = preload("uid://3srexa6ammer")
const ADRIA = [
	ADRIA_01,
	ADRIA_02,
	ADRIA_03,
	ADRIA_04,
	ADRIA_05,
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

var dialogue_pause_point: float = 0
var tutorial_menu_opened: bool = false
var espectro_audio: AudioEffectInstance = null

var i: int = 4
var j: int = 0
var tutorial_interrupted: bool = false

var dialogue_ready: bool = true
var dialogue_paused: bool = false
var animation_paused: bool = false
var fish: Pez = null

var spawning_fish: bool = false
var test_containers: bool = false
var test_fish_containers: int = 0;
var head_cut: bool = true
var tail_cut: bool = true
var test_cut: bool = false
var test_cut_grab_container: bool = false
var current_points: int = 0
var test_bone_fish: bool = false
var test_remaining_fish: bool = false
var test_simulacrum: bool = false

var tutorial_interruptions := {
	[0, 1]: func(): tutorial_anim_player.play("highlight_containers"); tutorial_interrupted = false,
	[0, 3]: func(): tutorial_anim_player.play("show_mutant"); tutorial_interrupted = false,
	[0, 4]: func(): drop_fish(); tutorial_interrupted = false,
	[1, 3]: func(): start_grab_tutorial(),
	[1, 4]: func(): start_cut_tutorial(),
	[2, 0]: func(): drop_fish(); tutorial_interrupted = false,
	[3, 3]: func(): start_cut_and_drop_tutorial(),
	[3, 4]: func(): start_bone_fish_tutorial(),
	[4, 3]: func(): start_remaining_fish_tutorial(),
	[5, 0]: func(): start_simulacrum_test(),
}

@onready var game: Game = $Game
@onready var confirm_quit_tutorial: ConfirmationDialog = $ConfirmQuitTutorial

@onready var pez_1: TextureRect = $PECES/PEZ1
@onready var pez_2: TextureRect = $PECES/PEZ2
@onready var pez_3: TextureRect = $PECES/PEZ3 
@onready var pez_4: TextureRect = $PECES/PEZ4
@onready var pez_5: TextureRect = $PECES/PEZ5
@onready var pez_6: TextureRect = $PECES/PEZ6
@onready var pez_7: TextureRect = $PECES/SkewerPez5/PEZ7

@onready var tutorial_fish = [pez_1, pez_2, pez_3, pez_4, pez_5, pez_6, pez_7]

@onready var tooltip: Label = $CanvasLayer/Tooltip
@onready var arrow_1: TextureRect = $CanvasLayer/Arrow1
@onready var arrow_2: TextureRect = $CanvasLayer/Arrow2

@onready var fish_scene := preload("uid://dqy4ordentikc")
@onready var pez_fumon: CompressedTexture2D = preload("uid://dcjxjmqs7d7kw")

@onready var fish_anim_player: AnimationPlayer = $FishAnimPlayer
@onready var tutorial_anim_player: AnimationPlayer = $TutorialAnimPlayer
@onready var dialogue_player: AudioStreamPlayer = $Dialogos
@onready var cut_drag_fish: CompressedTexture2D = preload("uid://bm52r77o04e37")
@onready var bone_fish: CompressedTexture2D = preload("uid://ee2cmcq2me3g")


func _ready() -> void:
	espectro_audio = AudioServer.get_bus_effect_instance(3, 0)
	game.fish_entered_container.connect(on_fish_entered_container)
	reset_tutorial()
	MusicHandler.stop()
	GameHandler.set_rules([3, 1, 3])
	GameHandler.set_processable_rules([0, 1, 1])
	GameHandler.emit_change_rules()


func _process(_delta: float) -> void:
	handle_fish_animations()
	handle_dialogues()

	if fish == null:
		if test_containers:
			spawn_fish()

		if not head_cut or not tail_cut:
			spawn_fish()

		if test_cut_grab_container:
			spawn_fish([1, 1, 0, 2], cut_drag_fish)
			current_points = GameHandler.get_score()

		if test_bone_fish:
			spawn_fish([1, 1, 1, 2], bone_fish)
			current_points = GameHandler.get_score()

		if test_remaining_fish:
			GameHandler.add_level()
			GameHandler.advance_next_level()
			test_remaining_fish = false
			reset_tooltip(2)

		if test_simulacrum:
			test_simulacrum = false
			reset_tooltip(1)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("Esc"):
		if not tutorial_menu_opened:
			print("made mouse visible")
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			game.set_process(false)
			tutorial_menu_opened = true

			if dialogue_player.is_playing():
				dialogue_paused = true
				dialogue_pause_point = dialogue_player.get_playback_position()
				dialogue_player.stop()
			if tutorial_anim_player.is_playing():
				animation_paused = true
				tutorial_anim_player.pause()
			confirm_quit_tutorial.popup_centered()

	if not tutorial_menu_opened and not tutorial_interrupted and event.is_action_pressed("Space"):
		print("TUTO SKIPPED")
		dialogue_player.stop()
		tutorial_anim_player.play("RESET")
		_on_dialogos_finished()


func handle_fish_animations():
	if not dialogue_ready and not tutorial_menu_opened:
		var dB_level = espectro_audio.get_magnitude_for_frequency_range(0, 10000).length()
		if dB_level > 0.075 and not fish_anim_player.is_playing():
			fish_anim_player.play(str(i + 1) + "_talk")


func handle_dialogues():
	if not tutorial_menu_opened:
		if not tutorial_interrupted:
			if dialogue_ready:
				dialogue_ready = false
				tutorial_fish[i].visible = true
				tutorial_fish[i - 1].visible = false
				dialogue_player.stream = VOCES[i][j]
				dialogue_player.play()


func spawn_fish(data: Array = [], texture: CompressedTexture2D = null):
	if not spawning_fish:
		spawning_fish = true
		game.start_round()
		await get_tree().create_timer(0.3).timeout
		fish = game.last_fish
		fish.corte_cabeza.connect(cut_head)
		fish.corte_cola.connect(cut_tail)
		if not data.is_empty():
			fish.set_fish_data(data)
		if texture:
			fish.set_fish_texture(texture)


func drop_fish():
	print("VALUE OF FISH: ", fish)
	if fish:
		spawning_fish = false
		game._on_timer_timeout()


func handle_dialogue_interruption():
	print("POSICIÓN ACTUAL: ", i, j)
	var current_pos := [i, j]
	if tutorial_interruptions.has(current_pos):
		tutorial_interrupted = true
		tutorial_interruptions[current_pos].call()


func handle_dialogue_position():
	j += 1
	if j >= VOCES[i].size():
		j = 0
		i += 1
		if i >= VOCES.size():
			i = 0


func start_grab_tutorial():
	tooltip.text = "Mantén clic izquierdo sobre un pez para agarrarlo.\nMete dos peces en contenedores."
	tooltip.visible = true
	tutorial_anim_player.play("highlight_containers_loop")
	test_containers = true
	test_fish_containers = 2


func start_cut_tutorial():
	tooltip.text = "Mantén clic derecho para sacar el cuchillo.\nPasa el cuchillo sobre la cabeza y la cola de un pez para cortarlas."
	tooltip.visible = true
	test_cut = true
	head_cut = false
	tail_cut = false


func start_cut_and_drop_tutorial():
	tooltip.text = "Corta la parte procesable del pez y tira el resto en el contenedor adecuado."
	tooltip.visible = true
	test_cut_grab_container = true


func start_bone_fish_tutorial():
	tooltip.text = "Si el cuerpo del pez está en las espinas es equivalente a que el cuerpo sea tóxico."
	tooltip.visible = true
	test_bone_fish = true


func start_remaining_fish_tutorial():
	for val in range(9, 0, -1):
		GameHandler.set_fishes_left(val)
		await get_tree().create_timer(0.15).timeout
	spawn_fish()
	tooltip.text = "Procesa el último pez que queda."
	tooltip.visible = true
	await get_tree().create_timer(0.3).timeout
	test_remaining_fish = true


func start_simulacrum_test():
	tooltip.text = "Fíjate en la tabla de reglas e intenta conseguir la puntuación máxima."
	tooltip.visible = true
	await get_tree().create_timer(0.3).timeout
	test_simulacrum = true


func cut_head(_text, _global_pos):
	if test_cut:
		head_cut = true
		if tail_cut:
			test_cut = false
			reset_tooltip(1)


func cut_tail(_text, _global_pos):
	if test_cut:
		tail_cut = true
		if head_cut:
			test_cut = false
			reset_tooltip(1)


func reset_tutorial():
	dialogue_pause_point = 0
	for tuto_fish in tutorial_fish:
		tuto_fish.visible = false


func finish_tutorial() -> void:
	dialogue_paused = false
	tutorial_finished.emit()
	MusicHandler.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("uid://4xe8awboiffn")


func on_fish_entered_container():
	spawning_fish = false

	if test_fish_containers > 0:
		test_fish_containers -= 1
	if test_containers and not test_fish_containers:
		test_containers = false
		reset_tooltip(1)

	print("GameHandler.get_score(): ", GameHandler.get_score())
	print("current_points + 3: ", current_points + 3)
	print("GameHandler.get_score() == current_points + 3: ", GameHandler.get_score() == current_points + 3)
	if test_cut_grab_container and GameHandler.get_score() == current_points + 3:
		test_cut_grab_container = false
		reset_tooltip(1)

	if test_bone_fish and GameHandler.get_score() == current_points + 3:
		test_bone_fish = false
		reset_tooltip(1)


func reset_tooltip(specific_time: float = 0):
	tutorial_anim_player.play("RESET")
	tooltip.visible = false
	if specific_time:
		await get_tree().create_timer(specific_time).timeout
	tutorial_interrupted = false


func _on_tutorial_confirmed() -> void:
	finish_tutorial()


func _on_tutorial_canceled() -> void:
	tutorial_menu_opened = false
	confirm_quit_tutorial.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	game.set_process(true)
	if dialogue_paused:
		dialogue_paused = false
		dialogue_player.play(dialogue_pause_point)
	if animation_paused:
		animation_paused = false
		tutorial_anim_player.play()


func _on_dialogos_finished() -> void:
	handle_dialogue_position()
	handle_dialogue_interruption()
	await get_tree().create_timer(0.5).timeout
	dialogue_ready = true


func _on_destructor_peces_body_entered(body: Node2D) -> void:
	if body.is_in_group("pez"):
		body.queue_free()

	if body.is_in_group("corte"):
		#print("DESTRUYENDO PEZ DEL FONDO")
		body.queue_free()

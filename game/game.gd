class_name Game
extends Node2D

signal fish_entered_container

enum PELIGROSIDAD {
	TOXICO,
	PROCESABLE,
}

#region MOUSE LOGIC VARIABLES
# Mouse tool modes
enum MouseTool {
	NONE,
	GRAB,
	KNIFE,
}

const NIVEL_TUTORIAL = 0

@export var round_time: float = 5
@export var level: int = 0
@export var tutorial_execution: bool = false

# POSIBLES PECES A SPAWNEAR = [OJOS, CABEZA, CUERPO, COLA]
var peces_posibles1: Array = [[0, 1, 2], [0, 1], [0], [0, 1, 2]]
var peces_posibles2: Array = [[0, 1, 2, 3], [0, 1, 2], [0, 1], [0, 1, 2, 3]]
var peces_posibles: Array = [peces_posibles1, peces_posibles2]

var current_tool := MouseTool.NONE

# Drag n drop logic LEFT MOUSE BUTTON
# Which fish is currently being dragged (null = none)
var dragged_fish: RigidBody2D = null
var last_fish: Pez = null

# Cutting logic variables RIGHT MOUSE BUTTON
var is_cutting: bool = false
var cut_points: Array = []

@onready var fish_scene: PackedScene = preload("res://game/pez/pez.tscn")

@onready var hand_open: Texture2D = preload("res://ui/mano/mano_abierta.png")
@onready var hand_grab: Texture2D = preload("res://ui/mano/mano_cerrada.png")
@onready var hand_knife: Texture2D = preload("res://ui/mano/mano_cuchillo.png")

@onready var pinza: AnimatedSprite2D = $HUD/Pinza
@onready var mano: Sprite2D = $HUD/Mano
#endregion

@onready var timer: Timer = $Timer
@onready var spawner: Marker2D = $Spawner
@onready var line_2d: Line2D = $HUD/Line2D
@onready var mesa_trampilla: Trampilla = $MesaTrampilla
@onready var cabeza_aux: PackedScene = preload("res://game/pez/cabeza_aux.tscn")
@onready var cola_aux: PackedScene = preload("res://game/pez/cola_aux.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pause_menu: Pause_Menu = $PauseMenu


func _ready() -> void:
	mesa_trampilla.pez_destruido.connect(on_fish_destroyed)
	GameHandler.transition_finished.connect(_on_transition_finished)

	GameHandler.reset_round()
	GameHandler.add_score(0)

	MusicHandler.load_track(GameHandler.game_music)
	MusicHandler.change_db_to(1)
	MusicHandler.play()

	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	GameHandler.randomize_rules()
	if not tutorial_execution:
		start_round()
	else:
		pause_menu.in_tutorial = true

	GameHandler.set_start_time(Time.get_unix_time_from_system())


func _process(_delta: float) -> void:
	mano.global_position = get_global_mouse_position()

	match current_tool:
		MouseTool.GRAB:
			mano.texture = hand_grab
		MouseTool.KNIFE:
			mano.texture = hand_knife
		_:
			mano.texture = hand_open

	if is_cutting:
		var pos = get_global_mouse_position()
		line_2d.add_point(pos)
		cut_points.append(pos)

	if timer.is_stopped():
		return
	GameHandler.set_time(timer.time_left)


func _input(event):
	if event is InputEventMouseButton:
		# LEFT = grab tool
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				current_tool = MouseTool.GRAB
			else:
				current_tool = MouseTool.NONE
				release_fish()

		# RIGHT = knife tool
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				current_tool = MouseTool.KNIFE
				start_cut()
			else:
				current_tool = MouseTool.NONE
				finish_cut()


func on_fish_destroyed() -> void:
	if not tutorial_execution:
		await get_tree().create_timer(0.25).timeout

		if GameHandler.fishes_left <= 0:
			on_set_finished()
			return
		start_round()
	else:
		fish_entered_container.emit()


func start_round():
	if not tutorial_execution:
		timer.start(round_time)
	animation_player.play("spawn_fish")


func randomize_fish_characteristics(fish: RigidBody2D) -> void:
	var max_random: int = min(GameHandler.get_level(), 2)
	var random = randi_range(0, max_random)
	#var fish_texture = GameHandler.path[random].pick_random()
	#var file_name = fish_texture.resource_path.get_file()
	var text_path = GameHandler.paths_levels[random].pick_random()
	var valuesStr = text_path.get_basename().split(",")
	var nums: Array[int] = []
	for v in valuesStr:
		nums.append(v.to_int())

	fish.set_fish_texture(load(text_path))
	fish.set_fish_data([nums[0], nums[1], nums[2], nums[3]])


func spawn_fish():
	last_fish = fish_scene.instantiate()
	spawner.add_child(last_fish)
	randomize_fish_characteristics(last_fish)

	last_fish.global_position = spawner.global_position
	last_fish.clicked.connect(_on_fish_clicked)

	if not tutorial_execution:
		GameHandler.set_fishes_left(GameHandler.fishes_left - 1)


func on_set_finished():
	timer.stop()
	spawner.get_children().map(func(c): c.queue_free())

	set_process(false)
	GameHandler.advance_next_level()


func start_grab(fish: Pez):
	if dragged_fish != null:
		return

	dragged_fish = fish
	fish.start_drag(get_global_mouse_position())


func release_fish():
	if dragged_fish:
		dragged_fish.stop_drag()
		dragged_fish = null


func start_cut():
	is_cutting = true
	cut_points.clear()
	line_2d.clear_points()
	line_2d.add_point(get_global_mouse_position())


func finish_cut():
	is_cutting = false
	for fish in spawner.get_children():
		test_cut_against_fish(fish)
	line_2d.clear_points()


func test_cut_against_fish(fish: RigidBody2D):
	var space := get_world_2d().direct_space_state

	var hit_head := false
	var hit_tail := false
	var hit_body := false

	for p in cut_points:
		var query := PhysicsPointQueryParameters2D.new()
		query.position = p
		query.collide_with_areas = true
		query.collide_with_bodies = false

		var result = space.intersect_point(query)

		for hit in result:
			if hit.collider == fish.get_node_or_null("CorteCabeza"):
				hit_head = true
			elif hit.collider == fish.get_node_or_null("CorteCuerpo"):
				hit_body = true
			elif hit.collider == fish.get_node_or_null("CorteCola"):
				hit_tail = true
			else:
				continue
	# Forbidden area cancels the cut
	if hit_body:
		return

	if hit_head:
		fish.corte_cabeza.connect(crear_cabeza_independiente)
		fish.cut_head()

	if hit_tail:
		fish.corte_cola.connect(crear_cola_independiente)
		fish.cut_tail()


func crear_cabeza_independiente(new_text: CompressedTexture2D, new_pos: Vector2) -> void:
	var corte: CabezaPez = cabeza_aux.instantiate()
	spawner.add_child(corte)
	corte.set_texture(new_text)
	corte.clicked.connect(_on_fish_clicked)
	corte.global_position = new_pos - Vector2(65, 0)
	# Por qué este 65 mágico?
	# Debería ser 320 pixeles a la izq que cada sección del pez son 640 
	# y como la pos 0,0 de la textura está en la mitad, se movería eso para 
	# que spawnee aproximadamente donde ya está la cabeza
	# Sin embargo, la textura del pez está escalada a 0.2, por lo que 320/5 = 64
	# Le pongo 1 pixel más de margen para que no colisione al spawnear y haga cosas raras


func crear_cola_independiente(new_text: CompressedTexture2D, new_pos: Vector2) -> void:
	var corte: ColaPez = cola_aux.instantiate()
	spawner.add_child(corte)
	corte.set_texture(new_text)
	corte.clicked.connect(_on_fish_clicked)
	corte.global_position = new_pos + Vector2(65, 0)
	# Arriba está explicado


func cut_fish():
	line_2d.add_point(get_local_mouse_position())


func _on_transition_finished() -> void:
	set_process(true)
	if GameHandler.fishes_left <= 0:
		on_set_finished()
		return
	start_round()


func _on_fish_clicked(fish):
	match current_tool:
		MouseTool.GRAB:
			start_grab(fish)
		MouseTool.KNIFE:
			cut_fish()


func _on_timer_timeout() -> void:
	if dragged_fish and dragged_fish.is_in_group("pez"):
		last_fish.explode()
		await get_tree().create_timer(0.5).timeout
		if GameHandler.add_score(-3):
			on_fish_destroyed()
		return

	if last_fish:
		last_fish.change_collision_mask()
		mesa_trampilla.fish_timeout()


func _on_destructor_peces_body_entered(body: Node2D) -> void:
	if body.is_in_group("pez"):
		body.queue_free()
		if GameHandler.add_score(-3):
			on_fish_destroyed()

	if body.is_in_group("corte"):
		#print("DESTRUYENDO PEZ DEL FONDO")
		body.queue_free()

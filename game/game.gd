extends Node2D

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

@export var fish_scene: PackedScene
@export var round_time: float = 5.2
@export var level: int = -1
@export var hand_open: Texture2D
@export var hand_grab: Texture2D
@export var hand_knife: Texture2D

# POSIBLES PECES A SPAWNEAR = [OJOS, CABEZA, CUERPO, COLA]
var peces_posibles1: Array = [[0, 1, 2], [0, 1], [0], [0, 1, 2]]
var peces_posibles2: Array = [[0, 1, 2, 3], [0, 1, 2], [0, 1], [0, 1, 2, 3]]
var peces_posibles: Array = [peces_posibles1, peces_posibles2]

# PECES PELIGROSOS: 
var peces_peligrosos1: Array = [[1], [0, 1], [0, 1, 2]]
var peces_peligrosos2: Array = [[2, 3, 4], [0, 1, 2], [0, 1, 2, 3]]
var peces_peligrosos3: Array = [[2, 3, 4, 5], [0, 1, 2, 3], [0, 1, 2, 3]]
var peces_peligrosos: Array = [peces_peligrosos1, peces_peligrosos2, peces_peligrosos3]
var current_tool := MouseTool.NONE

# Drag n drop logic LEFT MOUSE BUTTON
# Which fish is currently being dragged (null = none)
var dragged_fish: RigidBody2D = null
var last_fish: RigidBody2D = null

# Cutting logic variables RIGHT MOUSE BUTTON
var is_cutting := false
var cut_points := []

#@onready var set_transition: CanvasLayer = $SetTransition
var file_names
var resources

@onready var pinza: AnimatedSprite2D = $SFX/Pinza
@onready var mano: Sprite2D = $Cursor/Mano
#endregion

@onready var timer: Timer = $Timer
@onready var spawner: Marker2D = $Spawner
@onready var line_2d: Line2D = $Cursor/Line2D
@onready var cinta_fondo: AnimatedSprite2D = $CintaFondo
@onready var set_transition: CanvasLayer = $SetTransition
@onready var game_music: AudioStream = preload("res://music/InGame1.mp3")
@onready var mesa_trampilla: Node2D = $MesaTrampilla
@onready var cabeza_aux: PackedScene = preload("res://game/pez/cabeza_aux.tscn")
@onready var cola_aux: PackedScene = preload("res://game/pez/cola_aux.tscn")


func _ready() -> void:
	cinta_fondo.play("default")
	GameHandler.reset_round()
	MusicHandler.load_track(game_music)
	MusicHandler.play()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	start_next_set()
	start_round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer.is_stopped():
		return
	GameHandler.set_time(timer.time_left)
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


func start_next_set():
	level += 1
	if level > 2:
		end_game()
		return

	var rules: Array
	for i in range(3):
		rules.append(peces_peligrosos[level][i].pick_random())

	#print("Las reglas de peces peligrosos son: ", rules)
	GameHandler.start_next_set(rules)


func start_round():
	GameHandler.set_time(round_time)
	GameHandler.add_score(0)
	timer.start(round_time)
	spawn_fish()


func randomize_fish_characteristics(fish: RigidBody2D) -> void:
	var random = randi_range(0, level)
	var fish_texture = GameHandler.fish_sprites[random].pick_random()
	var file_name = fish_texture.resource_path.get_file()
	var valuesStr = file_name.get_basename().split(",")
	var nums: Array[int] = []
	for v in valuesStr:
		nums.append(v.to_int())

	fish.set_fish_texture(fish_texture)
	fish.set_fish_data([nums[0], nums[1], nums[2], nums[3]])


func spawn_fish():
	if GameHandler.fishes_left <= 0:
		on_set_finished()
		return

	if not last_fish == null:
		mesa_trampilla.new_fish_spawned(last_fish)

	pinza.play("default")
	await get_tree().create_timer(0.18).timeout
	last_fish = fish_scene.instantiate()
	spawner.add_child(last_fish)
	randomize_fish_characteristics(last_fish)

	last_fish.global_position = spawner.global_position
	last_fish.clicked.connect(_on_fish_clicked)

	GameHandler.set_fishes_left(GameHandler.fishes_left - 1)


func on_set_finished():
	timer.stop()

	for spawn_child in spawner.get_children():
		spawn_child.queue_free()
	# This reset does not reset score
	GameHandler.reset_round()

	await get_tree().process_frame
	set_transition.play()

	start_next_set()
	round_time = 6.3
	#print("TESTING")
	start_round()
	round_time = 5.2


func end_game():
	GameHandler.reset_score()
	get_tree().call_deferred("change_scene_to_file", "res://ui/main_menu/main_menu.tscn")
	#print("Game Over")


func start_grab(fish):
	#print("Dragged Fish: ", dragged_fish)
	if dragged_fish != null:
		return

	dragged_fish = fish
	# Tell the fish it is being dragged
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
	# Test cut against all fish
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
	var corte: RigidBody2D = cabeza_aux.instantiate()
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
	var corte: RigidBody2D = cola_aux.instantiate()
	spawner.add_child(corte)
	corte.set_texture(new_text)
	corte.clicked.connect(_on_fish_clicked)
	corte.global_position = new_pos + Vector2(65, 0)
	# Arriba está explicado

func cut_fish():
	line_2d.add_point(get_local_mouse_position())


func _on_fish_clicked(fish):
	match current_tool:
		MouseTool.GRAB:
			start_grab(fish)
		MouseTool.KNIFE:
			cut_fish()


func _on_timer_timeout() -> void:
	mesa_trampilla.fish_timeout()
	start_round()

extends CharacterBody2D

#region Caracteristicas de los peces
enum NUM_OJOS {
	UNO,
	DOS,
	TRES,
	CUATRO,
	CINCO,
	SEIS,
}

enum ESTADO_CABEZA {
	SIN_MANCHAS,
	CON_MANCHAS,
	SOMBRERO,
	FUMADOR,
	CORTADA,
}

enum ESTADO_CUERPO {
	BUENO,
	MALO,
}

enum TIPO_COLA {
	DELGADA,
	REDONDA,
	ABANICO,
	CON_MANCHAS,
	CORTADA,
}

#endregion

@export var PID: int = -1

@export var textura: Texture
@export var ojos: NUM_OJOS
@export var cabeza: ESTADO_CABEZA
@export var cuerpo: ESTADO_CUERPO
@export var cola: TIPO_COLA

#region # DRAG N DROP VARIABLES
@export var gravity := 2000.0
@export var drag_speed := 20.0
var is_dragged: bool = false
var grab_offset := Vector2.ZERO
signal clicked(fish)
#endregion

@onready var sprite_cabeza: Sprite2D = $Cabeza
@onready var sprite_cola: Sprite2D = $Cola



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_dragged:
		var target := get_global_mouse_position() - grab_offset
		velocity = (target - global_position) * drag_speed
	else:
		velocity.y += gravity * delta
	move_and_slide()

func start_drag(mouse_pos: Vector2):
	is_dragged = true
	grab_offset = mouse_pos - global_position

func stop_drag():
	is_dragged = false

#func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
#			dragging = false


func get_fish_data():
	return [ojos, cabeza, cuerpo, cola]


func _on_corte_cabeza_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event == null:
		return

	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#TODO Hay que cortar la textura de la cabeza de alguna forma y cambiar su estado a cortada
		pass

func cut_head():
	if cabeza == ESTADO_CABEZA.CORTADA:
		return

	sprite_cabeza.visible = false

func cut_tail():
	if cola == TIPO_COLA.CORTADA:
		return

	cola = TIPO_COLA.CORTADA
	sprite_cola.visible = false
	#$TailBlood.emitting = true

func _on_corte_cola_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event == null:
		return

	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#TODO Hay que cortar la textura de la cola de alguna forma y cambiar su estado a cortada
		pass


func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if _event is InputEventMouseButton and _event.button_index == MOUSE_BUTTON_LEFT and _event.pressed:
		emit_signal("clicked", self)
		print("clicked")

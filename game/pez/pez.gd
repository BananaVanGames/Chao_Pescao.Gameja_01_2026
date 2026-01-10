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
	CON_MANCHAS,
	SIN_MANCHAS,
	SOMBRERO,
	FUMADOR,
	CORTADA,
}

enum ESTADO_CUERPO {
	CON_MANCHAS,
	SIN_MANCHAS,
	JERINGUILLA,
	PODRIDO,
	ESQUELETO,
}

enum TIPO_COLA {
	CON_MANCHAS,
	DELGADA,
	REDONDA,
	ABANICO,
	CORTADA,
}

#endregion

@export var PID: int = -1
@export var gravity := 1200.0
@export var drag_speed := 20.0
@export var textura: Texture
@export var ojos: NUM_OJOS
@export var cabeza: ESTADO_CABEZA
@export var cuerpo: ESTADO_CUERPO
@export var cola: TIPO_COLA


var dragging: bool = false
var grab_offset := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if dragging:
		var target := get_global_mouse_position() - grab_offset
		velocity = (target - global_position) * drag_speed
		move_and_slide()
	else:
		velocity.y += gravity * delta
		move_and_slide()


func _on_corte_cabeza_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event == null:
		return

	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#TODO Hay que cortar la textura de la cabeza de alguna forma y cambiar su estado a cortada
		pass


func _on_corte_cola_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event == null:
		return

	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#TODO Hay que cortar la textura de la cola de alguna forma y cambiar su estado a cortada
		pass

			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			dragging = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if Input.is_action_just_pressed("click") and not dragging:
			dragging = true
			grab_offset = get_global_mouse_position() - global_position
			print("selected")

extends RigidBody2D

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
@export var textura: Texture
@export var ojos: NUM_OJOS
@export var cabeza: ESTADO_CABEZA
@export var cuerpo: ESTADO_CUERPO
@export var cola: TIPO_COLA


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


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

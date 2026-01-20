extends RigidBody2D

signal clicked(fish)
signal corte_cabeza
signal corte_cola

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
}

#region # DRAG N DROP VARIABLES
@export var gravity := 1000.0
@export var drag_speed := 20.0

#endregion

var ojos: NUM_OJOS = NUM_OJOS.UNO
var cabeza: ESTADO_CABEZA = ESTADO_CABEZA.SIN_MANCHAS
var cuerpo: ESTADO_CUERPO = ESTADO_CUERPO.BUENO
var cola: TIPO_COLA = TIPO_COLA.ABANICO
var cabeza_cortada: bool = false
var cola_cortada: bool = false

var is_dragged: bool = false
var grab_offset := Vector2.ZERO
var fish_texture: CompressedTexture2D = null

#endregion

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_cabeza: Sprite2D = $Cabeza
@onready var sprite_cuerpo: Sprite2D = $Cuerpo
@onready var sprite_cola: Sprite2D = $Cola
@onready var cabeza_col_shape: CollisionShape2D = $CabezaColShape
@onready var cola_col_shape: CollisionShape2D = $ColaColShape


func _physics_process(delta: float) -> void:
	if is_dragged:
		var target := get_global_mouse_position() - grab_offset
		linear_velocity = (target - global_position) * drag_speed
	else:
		linear_velocity.y += gravity * delta


func start_drag(mouse_pos: Vector2):
	is_dragged = true
	grab_offset = mouse_pos - global_position


func stop_drag():
	is_dragged = false


func explode():
	animation_player.play("death")


func set_fish_data(values: Array):
	ojos = values[0]
	cabeza = values[1]
	cuerpo = values[2]
	cola = values[3]


func get_fish_data() -> Array:
	return [ojos, cabeza, cuerpo, cola, cabeza_cortada, cola_cortada]


func set_fish_texture(texture: CompressedTexture2D) -> void:
	fish_texture = texture
	sprite_cabeza.texture = fish_texture
	sprite_cuerpo.texture = fish_texture
	sprite_cola.texture = fish_texture


func cut_head():
	sprite_cabeza.visible = false
	cabeza_cortada = true
	corte_cabeza.emit(fish_texture, global_position)
	cabeza_col_shape.disabled = true

func cut_tail():
	sprite_cola.visible = false
	cola_cortada = true
	corte_cola.emit(fish_texture, global_position)
	cola_col_shape.disabled = true


func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if _event is InputEventMouseButton and _event.button_index == MOUSE_BUTTON_LEFT and _event.pressed:
		clicked.emit(self)

extends CharacterBody2D

signal clicked(fish)

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

#endregion

#region # DRAG N DROP VARIABLES
@export var gravity := 1000.0
@export var drag_speed := 20.0

var ojos: NUM_OJOS = NUM_OJOS.UNO
var cabeza: ESTADO_CABEZA = ESTADO_CABEZA.SIN_MANCHAS
var cuerpo: ESTADO_CUERPO = ESTADO_CUERPO.BUENO
var cola: TIPO_COLA = TIPO_COLA.ABANICO
var cabeza_cortada: bool = false
var cola_cortada: bool = false

var is_dragged: bool = false
var grab_offset := Vector2.ZERO

#endregion

@onready var sprite_cabeza: Sprite2D = $Cabeza
@onready var sprite_cuerpo: Sprite2D = $Cuerpo
@onready var sprite_cola: Sprite2D = $Cola
@onready var death_explosion: AnimatedSprite2D = $DeathExplosion


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

func explode():
	death_explosion.visible = true
	death_explosion.play("default")
	sprite_cabeza.visible = false
	sprite_cuerpo.visible = false
	sprite_cola.visible = false
	await death_explosion.animation_finished
	queue_free()

func set_fish_data(values: Array):
	ojos = values[0]
	cabeza = values[1]
	cuerpo = values[2]
	cola = values[3]


func get_fish_data() -> Array:
	return [ojos, cabeza, cuerpo, cola, cabeza_cortada, cola_cortada]


func set_fish_texture(texture: CompressedTexture2D) -> void:
	sprite_cabeza.texture = texture
	sprite_cuerpo.texture = texture
	sprite_cola.texture = texture


func cut_head():
	sprite_cabeza.visible = false
	cabeza_cortada = true

func cut_tail():
	sprite_cola.visible = false
	cola_cortada = true


func _on_corte_cabeza_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event == null:
		return

	if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#TODO Hay que cortar la textura de la cabeza de alguna forma y cambiar su estado a cortada
		pass
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

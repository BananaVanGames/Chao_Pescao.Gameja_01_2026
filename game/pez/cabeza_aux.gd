class_name CabezaPez
extends Pez

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	pass


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


func set_texture(new_texture: CompressedTexture2D):
	sprite.texture = new_texture


func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if _event is InputEventMouseButton and _event.button_index == MOUSE_BUTTON_LEFT and _event.pressed:
		clicked.emit(self)

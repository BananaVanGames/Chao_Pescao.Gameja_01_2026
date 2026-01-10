extends Node2D

#region #
@export var punch_distance := 120.0
@export var punch_speed := 1200.0
@export var force := Vector2(-600, 0) # force applied to fish (left)

#endregion

var start_position: Vector2
var state := "idle" # idle, forward, back


func _ready():
	start_position = global_position


func _physics_process(delta):
	match state:
		"forward":
			global_position.x -= punch_speed * delta
			if global_position.x <= start_position.x - punch_distance:
				state = "back"

		"back":
			global_position.x += punch_speed * delta
			if global_position.x >= start_position.x:
				global_position = start_position
				state = "idle"


func trigger_punch():
	if state != "idle":
		return
	state = "forward"

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if state != "forward":
		return
	if body is CharacterBody2D:
		body.velocity += force

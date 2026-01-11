extends Node2D

#region #
@export var punch_distance := 500.0
@export var punch_speed := 1250.0
@export var force := Vector2(-5000, 0) # force applied to fish (left)

var start_position: Vector2
var state := "idle" # idle, forward, back

#endregion
@onready var punch_area: Area2D = $PunchArea
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	start_position = punch_area.position


func _physics_process(delta):
	match state:
		"forward":
			punch_area.position.x -= punch_speed * delta
			if punch_area.position.x <= start_position.x - punch_distance:
				state = "back"

		"back":
			punch_area.position.x += punch_speed * delta
			if punch_area.position.x >= start_position.x:
				punch_area.position = start_position
				state = "idle"


func trigger_punch():
	if state != "idle":
		return
	state = "forward"
	animated_sprite_2d.play("hit")
	GameHandler.open_door_animation()


func _on_punch_area_body_entered(body: Node2D) -> void:
	if state != "forward":
		return
	if body is CharacterBody2D:
		body.velocity += force

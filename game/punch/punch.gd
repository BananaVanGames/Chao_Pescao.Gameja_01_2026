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
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	start_position = punch_area.position


func throw_punch():
	animation_player.play("hit")


func _on_punch_area_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.linear_velocity += force

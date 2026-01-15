extends Node2D

var pez_en_mesa: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var punch: Node2D = $Punch
@onready var detector_de_peces: Area2D = $DetectorDePeces


func fish_timeout() -> void:
	if pez_en_mesa:
		animation_player.play("open")
		punch.throw_punch()


func new_fish_spawned(last_fish: CharacterBody2D) -> void:
	if not pez_en_mesa:
		last_fish.explode()


func _on_basura_peces_body_entered(body: Node2D) -> void:
	if body.is_in_group("pez"):
		GameHandler.add_score(-3)


func _on_detector_de_peces_body_entered(body: Node2D) -> void:
	if body.is_in_group("pez"):
		pez_en_mesa = true


func _on_detector_de_peces_body_exited(body: Node2D) -> void:
	if body.is_in_group("pez"):
		pez_en_mesa = false

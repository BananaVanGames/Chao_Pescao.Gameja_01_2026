class_name Trampilla
extends Node2D

signal pez_destruido

var pez_en_mesa: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var punch: Node2D = $Punch
@onready var detector_de_peces: Area2D = $DetectorDePeces
@onready var score_zone: Node2D = $ScoreZone


func _ready() -> void:
	score_zone.pez_clasificado.connect(on_pez_clasificado)


func on_pez_clasificado() -> void:
	pez_destruido.emit()


func fish_timeout() -> void:
	if pez_en_mesa:
		animation_player.play("open")
		punch.throw_punch()


func _on_detector_de_peces_body_entered(body: Node2D) -> void:
	if body.is_in_group("pez"):
		pez_en_mesa = true


func _on_detector_de_peces_body_exited(body: Node2D) -> void:
	if body.is_in_group("pez"):
		pez_en_mesa = false

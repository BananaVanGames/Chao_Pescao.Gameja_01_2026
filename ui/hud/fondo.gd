extends Node2D

@onready var fish_scene := preload("res://game/pez/pez.tscn")
@onready var spawner_fondo: Marker2D = $SpawnerFondo
@onready var cinta_fondo: AnimatedSprite2D = $CintaFondo


func _ready() -> void:
	cinta_fondo.play("run")


func randomize_fish_characteristics(fish: RigidBody2D) -> void:
	var random = randi_range(0, min(GameHandler.level, 2))
	var fish_texture = GameHandler.fish_sprites[random].pick_random()
	var file_name = fish_texture.resource_path.get_file()
	var valuesStr = file_name.get_basename().split(",")
	var nums: Array[int] = []
	for v in valuesStr:
		nums.append(v.to_int())

	fish.set_fish_texture(fish_texture)
	fish.set_fish_data([nums[0], nums[1], nums[2], nums[3]])


func _on_timer_fondo_timeout() -> void:
	var new_fish = fish_scene.instantiate()
	spawner_fondo.add_child(new_fish)
	randomize_fish_characteristics(new_fish)
	new_fish.global_position = spawner_fondo.global_position
	new_fish.gravity_scale = 0
	new_fish.z_index = -98
	new_fish.remove_from_group("pez")
	new_fish.add_to_group("corte")
	new_fish.set_collision_layer_value(1, false)
	new_fish.set_collision_mask_value(1, false)
	new_fish.set_physics_process(false)
	new_fish.linear_velocity.x = 500

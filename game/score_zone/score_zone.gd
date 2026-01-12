extends Node2D

const OJOS_PEZ = 0
const CABEZA_PEZ = 1
const CUERPO_PEZ = 2
const COLA_PEZ = 3
const OJOS_RULES = 0
const CABEZA_RULES = 1
const COLA_RULES = 2
const CABEZA_CORTADA = 4
const COLA_CORTADA = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func apply_rule(condicion: bool, toxico: int, parte_cortada: bool) -> int:
	if not condicion:
		if parte_cortada:
			return - 1
		else:
			return 0

	if parte_cortada:
		return 0
	else:
		if toxico == 0:
			return - 2
		else:
			return - 1


func _on_good_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	var fish_data = body.get_fish_data()
	var current_rules = GameHandler.get_current_rules()
	var danger_rules = GameHandler.get_danger_rules()

	print("Fish data: ", fish_data)
	print("Current rules: ", current_rules)
	print("Danger rules: ", danger_rules)
	var score := 2

	if fish_data[CUERPO_PEZ] == 1:
		GameHandler.add_score(-3)
		body.queue_free()
		return

	var cabeza_mal := false
	if fish_data[OJOS_PEZ] > current_rules[OJOS_RULES]:
		cabeza_mal = true

	if fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES] and fish_data[CABEZA_PEZ] != 0:
		cabeza_mal = true
	var cabeza_cortada = fish_data[CABEZA_CORTADA]
	
	if cabeza_mal:
		if not cabeza_cortada:
			# Debía cortarse pero no se cortó
			if not danger_rules[0]:
				score = -3
			else:
				score -= 1
	else:
		if cabeza_cortada:
			# No debía cortarse pero se cortó
			score -= 1
	print("Score después de la cabeza: ", score)
	if score != -3:
		if fish_data[COLA_PEZ] == current_rules[COLA_RULES]:
			if not fish_data[COLA_CORTADA]:
				if not danger_rules[2]:
					score = -3
				else:
					score -= 1
		else:
			if fish_data[COLA_CORTADA]:
				score -= 1
	print("Score después de la cola: ", score)

	if score == 2 and GameHandler.get_time() > 1.00:
		#print("Punto extra por velocidad")
		score = 3

	print("Puntuación final añadida: ", score, "\n")
	GameHandler.add_score(score)
	body.queue_free()


func _on_bad_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	var fish_data = body.get_fish_data()
	print("Datos del pez: ", fish_data)
	if fish_data[CUERPO_PEZ] == 0:
		GameHandler.add_score(-3)
	else:
		GameHandler.add_score(1)

	body.queue_free()

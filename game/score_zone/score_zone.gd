extends Node2D

#region Constantes
const OJOS_PEZ = 0
const CABEZA_PEZ = 1
const CUERPO_PEZ = 2
const COLA_PEZ = 3

const OJOS_RULES = 0
const CABEZA_RULES = 1
const COLA_RULES = 2

const CABEZA_CORTADA = 4
const COLA_CORTADA = 5

const CABEZA_SANA = 0
const CUERPO_SANO = 0
const CUERPO_ENFERMO = 1

#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_good_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	var fish_data = body.get_fish_data()
	var current_rules = GameHandler.get_current_rules()
	var processable_rules = GameHandler.get_processable_rules()

	print("Fish data: ", fish_data)
	print("Current rules: ", current_rules)
	print("Danger rules: ", processable_rules)

	if fish_data[CUERPO_PEZ] == CUERPO_ENFERMO:
		GameHandler.add_score(-3)
		body.queue_free()
		return

	var score := 2
	var cabeza_mal := false

	if fish_data[OJOS_PEZ] > current_rules[OJOS_RULES]:
		cabeza_mal = true
	if fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES] and fish_data[CABEZA_PEZ] != CABEZA_SANA:
		cabeza_mal = true

	var cabeza_cortada = fish_data[CABEZA_CORTADA]

	if cabeza_mal:
		if not processable_rules[OJOS_RULES] or not processable_rules[CABEZA_RULES]:
			score = -3
		else:
			if not cabeza_cortada:
				score -= 1
	else:
		if cabeza_cortada:
			# No debía cortarse pero se cortó
			score -= 1
	print("Score después de la cabeza: ", score)
	if score != -3:
		if fish_data[COLA_PEZ] == current_rules[COLA_RULES]:
			if not processable_rules[COLA_RULES]:
				score = -3
			else:
				if not fish_data[COLA_CORTADA]:
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
	var current_rules = GameHandler.get_current_rules()
	var processable_rules = GameHandler.get_processable_rules()

	print("Fish data: ", fish_data)
	print("Current rules: ", current_rules)
	print("Danger rules: ", processable_rules)

	#Con este IF nos cercioramos de que el pez tiene al menos 1 parte tóxica
	if (
			fish_data[CUERPO_PEZ] == CUERPO_SANO
			or (
				processable_rules[OJOS_RULES]
				and processable_rules[COLA_RULES]
				and processable_rules[CABEZA_RULES]
				and current_rules[CABEZA_RULES] != CABEZA_SANA
			)
	):
		GameHandler.add_score(-3)
		body.queue_free()

	if (
			fish_data[OJOS_PEZ] <= current_rules[OJOS_RULES] and not processable_rules[OJOS_RULES]
			or fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES] and not processable_rules[CABEZA_RULES]
			or fish_data[COLA_PEZ] == current_rules[COLA_RULES] and not processable_rules[COLA_RULES]
	):
		pass

	var score := 2
	var cabeza_mal := false

	if fish_data[OJOS_PEZ] > current_rules[OJOS_RULES]:
		cabeza_mal = true
	if fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES] and fish_data[CABEZA_PEZ] != 0:
		cabeza_mal = true

	var cabeza_cortada = fish_data[CABEZA_CORTADA]

	if cabeza_mal:
		if processable_rules[0]:
			if cabeza_cortada:
				score -= 1
	else:
		if cabeza_cortada:
			score -= 1

	print("Score después de la cabeza: ", score)
	if score != -3:
		if fish_data[COLA_PEZ] == current_rules[COLA_RULES]:
			if not processable_rules[2]:
				score = -3
			else:
				if not fish_data[COLA_CORTADA]:
					score -= 1
		else:
			if fish_data[COLA_CORTADA]:
				score -= 1
	print("Score después de la cola: ", score)

	if score == 2 and GameHandler.get_time() > 1.00:
		#print("Punto extra por velocidad")
		score = 3

	body.queue_free()

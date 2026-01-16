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

	if not (
			fish_data[OJOS_PEZ] > current_rules[OJOS_RULES] and not processable_rules[OJOS_PEZ]
			or (fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES] and not processable_rules[CABEZA_RULES]
				and fish_data[CABEZA_PEZ] != CABEZA_SANA)
			or fish_data [CUERPO_PEZ] == CUERPO_ENFERMO
			or fish_data[COLA_PEZ] == current_rules[COLA_RULES] and not processable_rules[COLA_RULES]
	):
		GameHandler.add_score(-3)
		body.queue_free()
		return

	var score := 2
	var cabeza_mal := false

	if not fish_data [CUERPO_PEZ] == CUERPO_ENFERMO:
		if fish_data[OJOS_PEZ] > current_rules[OJOS_RULES]:
			cabeza_mal = true
		if fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES] and fish_data[CABEZA_PEZ] != CABEZA_SANA:
			cabeza_mal = true

		var cabeza_cortada = fish_data[CABEZA_CORTADA]

		if cabeza_mal:
			if not processable_rules[OJOS_RULES] or not processable_rules[CABEZA_RULES]:
				if cabeza_cortada:
					score -= 2
		print("Score después de la cabeza: ", score)

		if fish_data[COLA_PEZ] == current_rules[COLA_RULES]:
			if not processable_rules[COLA_RULES]:
				if fish_data[COLA_CORTADA]:
					score -= 2
		print("Score después de la cola: ", score)

	if score == 2 and GameHandler.get_time() > 1.00:
		score = 3

	print("Puntuación final añadida: ", score, "\n")
	GameHandler.add_score(score)
	body.queue_free()

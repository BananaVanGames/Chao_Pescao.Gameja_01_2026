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

	score += apply_rule(
		fish_data[OJOS_PEZ] > current_rules[OJOS_RULES],
		danger_rules[0],
		fish_data[CABEZA_CORTADA]
	)
	print("Puntuación de los ojos: ", score)

	if current_rules[CABEZA_RULES] != 0:
		score += apply_rule(
			fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES],
			danger_rules[1],
			fish_data[CABEZA_CORTADA]
		)
	print("Puntuación de la cabeza: ", score)

	score += apply_rule(
		fish_data[COLA_PEZ] == current_rules[COLA_RULES],
		danger_rules[2],
		fish_data[COLA_CORTADA]
	)
	print("Puntuación de la cola: ", score)

	if score == 2 and GameHandler.get_time() > 1.00:
		print("Punto extra por velocidad")
		score = 3

	print("Puntuación final añadida: ", score, "\n")
	GameHandler.add_score(score)
	body.queue_free()


func _on_bad_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	var fish_data = body.get_fish_data()

	if fish_data[2] == 0:
		GameHandler.add_score(-3)
	else:
		GameHandler.add_score(1)

	body.queue_free()

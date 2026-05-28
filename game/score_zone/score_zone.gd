extends Node2D

signal pez_clasificado

#region Constantes
const OJOS_PEZ: int = 0
const CABEZA_PEZ: int = 1
const CUERPO_PEZ: int = 2
const COLA_PEZ: int = 3

const OJOS_RULES: int = 0
const CABEZA_RULES: int = 1
const COLA_RULES: int = 2

const CABEZA_CORTADA: int = 4
const COLA_CORTADA: int = 5

const CABEZA_SANA: int = 0
const CUERPO_SANO: int = 0
const CUERPO_ENFERMO: int = 1

const MARGEN_PUNTOS_EXTRA: float = 1.00

#endregion

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_good_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	var fish_data = body.get_fish_data()
	var current_rules = GameHandler.get_rules()
	var processable_rules = GameHandler.get_processable_rules()

	#print("Fish data: ", fish_data)
	#print("Current rules: ", current_rules)
	#print("Danger rules: ", processable_rules)

	if fish_data[CUERPO_PEZ] == CUERPO_ENFERMO:
		if GameHandler.add_score(-3):
			pez_clasificado.emit()
		body.queue_free()
		return

	var score := 2

	var cabeza_cortada: bool = fish_data[CABEZA_CORTADA]
	var cola_cortada: bool = fish_data[COLA_CORTADA]

	var ojos_mal: bool = fish_data[OJOS_PEZ] > current_rules[OJOS_RULES]
	var cabeza_mal: bool = (
		fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES]
		and fish_data[CABEZA_PEZ] != CABEZA_SANA
	)
	var cola_mal: bool = fish_data[COLA_PEZ] == current_rules[COLA_RULES]

	var error_ojos: bool = false
	var error_cabeza: bool = false
	var error_cola: bool = false

	if ojos_mal:
		if not processable_rules[OJOS_RULES]:
			score = -3
			error_ojos = true
		elif not cabeza_cortada:
			score -= 1
			error_ojos = true
		
		if cabeza_mal and not processable_rules[CABEZA_RULES]:
			score = -3
			error_cabeza = true
	else:
		if cabeza_mal:
			if not processable_rules[CABEZA_RULES]:
				score = -3
				error_cabeza = true
			elif not cabeza_cortada and score != -3:
				score -= 1
				error_cabeza = true
		elif cabeza_cortada and score != -3:
			score -= 1

	if cola_mal:
		if not processable_rules[COLA_RULES]:
			score = -3
			error_cola = true
		elif not cola_cortada and score != -3:
			score -= 1
			error_cola = true
	elif cola_cortada and score != -3:
		score -= 1

	if score == 2 and GameHandler.get_time() > MARGEN_PUNTOS_EXTRA:
		score = 3

	GameHandler.trigger_rules_error([error_ojos, error_cabeza, error_cola])
	if GameHandler.add_score(score):
		pez_clasificado.emit()
	body.queue_free()


func _on_bad_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	var fish_data = body.get_fish_data()
	var current_rules = GameHandler.get_rules()
	var processable_rules = GameHandler.get_processable_rules()

	#print("Fish data: ", fish_data)
	#print("Current rules: ", current_rules)
	#print("Danger rules: ", processable_rules)

	var ojos_mal: bool = fish_data[OJOS_PEZ] > current_rules[OJOS_RULES]
	var cabeza_mal: bool = (
		fish_data[CABEZA_PEZ] == current_rules[CABEZA_RULES]
		and fish_data[CABEZA_PEZ] != CABEZA_SANA
	) or ojos_mal

	var cola_mal: bool = fish_data[COLA_PEZ] == current_rules[COLA_RULES]
	var cuerpo_mal: bool = fish_data[CUERPO_PEZ] == CUERPO_ENFERMO

	var cabeza_cortada: bool = fish_data[CABEZA_CORTADA]
	var cola_cortada: bool = fish_data[COLA_CORTADA]

	var toxic_parts: int = 0
	if ojos_mal and not processable_rules[OJOS_RULES] or cabeza_mal and not processable_rules[CABEZA_RULES]:
		toxic_parts += 1
	if cuerpo_mal:
		toxic_parts += 1
	if cola_mal and not processable_rules[COLA_RULES]:
		toxic_parts += 1

	if not toxic_parts:
		if GameHandler.add_score(-3):
			pez_clasificado.emit()
		body.queue_free()
		return

	var toxic_cut: int = 0

	if cabeza_mal and cabeza_cortada:
		if not processable_rules[OJOS_RULES] or not processable_rules[CABEZA_RULES]:
			toxic_cut += 1

	if cola_mal and cola_cortada and not processable_rules[COLA_RULES]:
		toxic_cut += 1

	var delta_score := -1

	if toxic_cut == 0:
		delta_score = 3 if GameHandler.get_time() > MARGEN_PUNTOS_EXTRA else 2
	elif toxic_cut == toxic_parts:
		delta_score = -3

	if GameHandler.add_score(delta_score):
		pez_clasificado.emit()
	body.queue_free()


func _on_open_good_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	animation_player.play("open_good_container")


func _on_open_good_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	animation_player.play("close_good_container")


func _on_open_bad_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	animation_player.play("open_bad_container")


func _on_open_bad_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("pez"):
		return

	animation_player.play("close_bad_container")

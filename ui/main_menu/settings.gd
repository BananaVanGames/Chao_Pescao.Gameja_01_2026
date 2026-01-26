extends VBoxContainer

const MIN_DB := -60.0
const MAX_DB := 0.0

@onready var master_spinbox: SpinBox = $Master/Master
@onready var music_spinbox: SpinBox = $Music/Musica
@onready var sfx_spinbox: SpinBox = $SFX/SFX


func _ready():
	for sb in [music_spinbox, sfx_spinbox]:
		sb.min_value = 0
		sb.max_value = 100
		sb.step = 1

	_sync_spinboxes()

	master_spinbox.value_changed.connect(_on_master_volume_changed)
	music_spinbox.value_changed.connect(_on_music_volume_changed)
	sfx_spinbox.value_changed.connect(_on_sfx_volume_changed)


func _sync_spinboxes():
	master_spinbox.value = _db_to_percent(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	)
	music_spinbox.value = _db_to_percent(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica"))
	)
	sfx_spinbox.value = _db_to_percent(
		AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	)


func _percent_to_db(value: float) -> float:
	if value <= 0.0:
		return MIN_DB

	var linear := value / 100.0
	return clamp(linear_to_db(linear), MIN_DB, MAX_DB)


func _db_to_percent(db: float) -> float:
	if db <= MIN_DB:
		return 0.0

	var linear := db_to_linear(db)
	return clamp(linear * 100.0, 0.0, 100.0)


func _set_volume(bus_name: String, value: float):
	var bus_index := AudioServer.get_bus_index(bus_name)
	var db := _percent_to_db(value)

	AudioServer.set_bus_volume_db(bus_index, db)
	AudioServer.set_bus_mute(bus_index, db <= MIN_DB)


func _on_master_volume_changed(value: float):
	_set_volume("Master", value)


func _on_music_volume_changed(value: float):
	_set_volume("Musica", value)


func _on_sfx_volume_changed(value: float):
	_set_volume("SFX", value)

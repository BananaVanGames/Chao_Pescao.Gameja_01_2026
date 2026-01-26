extends AudioStreamPlayer


func load_track(audio:AudioStream) -> void:
	stream = audio

func _ready() -> void:
	bus = "Musica"

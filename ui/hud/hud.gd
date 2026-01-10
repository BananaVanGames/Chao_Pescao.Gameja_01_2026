extends Control

@onready var timer_label: Label = $VBoxContainer/Timer
@onready var score_label: Label = $VBoxContainer/Score
@onready var fishes_left_label: Label = $VBoxContainer/FishesLeft

func _ready():
	GameHandler.time_changed.connect(_on_time_changed)
	GameHandler.score_changed.connect(_on_score_changed)
	GameHandler.fishes_left_changed.connect(_on_fishes_changed)

func _on_time_changed(value):
	timer_label.text = "TIEMPO: %d" % int(ceil(value))

func _on_score_changed(value):
	score_label.text = "SCORE: %d" % value

func _on_fishes_changed(value):
	fishes_left_label.text = "PESCADOS RESTANTES: %d" % value

extends Node

@onready var label = $Label
var time_left: float = 120.0   # starting time in seconds

func _ready():
	time_left = 10.0  # start countdown when Level.tscn starts

func _process(delta):
	if time_left > 0:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			get_tree().change_scene_to_file("res://EndScreen.tscn")

	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	label.text = "%02d : %02d" % [minute, second]

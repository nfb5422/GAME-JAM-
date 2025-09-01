extends Node

@onready var label = $Label

func _process(delta):
	var time_left = GameCountdown.get_time_left()
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	label.text = "%02d : %02d" % [minute, second]

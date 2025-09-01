extends Node

var timer := Timer.new()
var start_time := 0.0

func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.start(60)
	start_time = Time.get_ticks_msec() / 1000.0

func get_time_left() -> float:
	return timer.time_left

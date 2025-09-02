extends Area2D

# Ordered list of levels
var levels = [
	"res://Level.tscn",
	"res://Level2.tscn",
	"res://Level3.tscn"
]

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		var current_scene = get_tree().current_scene.scene_file_path
		var idx = levels.find(current_scene)

		if idx != -1 and idx + 1 < levels.size():
			# Load the next level
			get_tree().change_scene_to_file(levels[idx + 1])
		else:
			# No more levels -> go to win screen or restart
			
			get_tree().change_scene_to_file("res://endScreen.tscn")

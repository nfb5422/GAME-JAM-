extends Area2D

@export var wind_dir: Vector2 = Vector2(1, 0)   # Direction of push
@export var force: float = 400.0               # Strength of push per second
@export var only_gas: bool = true              # Only push GAS players?

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta):
	# Forward direction of the fan (X axis of the Area2D)
	var fan_forward = global_transform.x.normalized()
	
	# Push opposite the fan’s forward
	var push = -fan_forward * force * delta
	
	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			if only_gas and body.phase != body.Phase.GAS:
				continue
			body.move_and_collide(push)

extends CharacterBody2D

enum Phase { SOLID, LIQUID, GAS }

@export var is_player_one := true
@export var walk_speed := 220.0
@export var gravity_solid := 1400.0
@export var gravity_liquid := 2200.0
@export var gravity_gas := 120.0
@export var gas_lift := 480.0
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
var phase := Phase.SOLID
var can_be_gas := true
var left_action: String
var right_action: String
var gas_action: String
var liq_action: String

func _ready():
	if is_player_one:
		left_action = "p1_left"
		right_action = "p1_right"
		gas_action = "p1_gas"
		liq_action = "p1_liquid"


func _physics_process(delta):
	if phase == Phase.SOLID or phase == Phase.LIQUID:
		if (phase == Phase.SOLID or phase == Phase.LIQUID) and (is_on_floor() or is_on_ceiling() or is_on_wall()):
			can_be_gas = true

	if Input.is_action_pressed(gas_action) and can_be_gas:
		_set_phase(Phase.GAS)
	elif Input.is_action_pressed(liq_action):
		_set_phase(Phase.LIQUID)
	elif Input.is_action_just_pressed(left_action) or Input.is_action_just_pressed(right_action):
		_set_phase(Phase.SOLID)

	var dir := int(Input.is_action_pressed(right_action)) - int(Input.is_action_pressed(left_action))
	velocity.x = dir * walk_speed
  
	if dir != 0 and sprite:
		sprite.flip_h = dir < 0

	match phase:
		Phase.SOLID:
			velocity.y += gravity_solid * delta * 5.5
		Phase.LIQUID:
			velocity.y = 350
			velocity.x = dir * 600
		 
		Phase.GAS:
			velocity.y = -600.0       
			

	move_and_slide()

func _set_phase(p: Phase) -> void:
	if phase == p:
		return
	var was_on_floor := is_on_floor()
	phase = p
	if p == Phase.GAS:
		can_be_gas = false

	
	if sprite:
		if p == Phase.SOLID:
			sprite.modulate = Color(1,1,1,1)
			sprite.scale = Vector2(1, 1)
			sprite.texture = preload("res://solid.png")
		elif p == Phase.LIQUID:
			sprite.modulate = Color(0.6,0.8,1,1)
			sprite.scale = Vector2(2, 1)
			sprite.texture = preload("res://liquid.png")
		elif p == Phase.GAS:
			sprite.modulate = Color(1,1,1,0.65)
			sprite.scale = Vector2(1, 1)
			sprite.texture = preload("res://gas.png")

	
	if p == Phase.GAS:
		set_collision_mask_value(1, false)   
		set_collision_mask_value(4, true)
		set_collision_mask_value(5, true)
		if was_on_floor and velocity.y >= 0.0:
			velocity.y = -60.0
			
	if p == Phase.LIQUID	:
		set_collision_mask_value(4, true)
		set_collision_mask_value(5, false)  	  
	else:
		set_collision_mask_value(1, true)
		set_collision_mask_value(4, false)
		set_collision_mask_value(5, true) 
		floor_snap_length = 6.0

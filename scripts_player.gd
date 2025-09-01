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
	else:
		left_action = "p2_left"
		right_action = "p2_right"
		gas_action = "p2_gas"
		liq_action = "p2_liquid"

func _physics_process(delta):
	if Input.is_action_pressed(gas_action):
		_set_phase(Phase.GAS)
	elif Input.is_action_pressed(liq_action):
		_set_phase(Phase.LIQUID)
	else:
		_set_phase(Phase.SOLID)

	var dir := int(Input.is_action_pressed(right_action)) - int(Input.is_action_pressed(left_action))
	velocity.x = dir * walk_speed

	match phase:
		Phase.SOLID:
			velocity.y += gravity_solid * delta
		Phase.LIQUID:
			velocity.y = 400.0        # test: aşağı sabit hız
		Phase.GAS:
			velocity.y = -300.0       # test: yukarı sabit hız
			velocity.x = 0
	move_and_slide()

func _set_phase(p: Phase) -> void:
	if phase == p:
		return
	var was_on_floor := is_on_floor()
	phase = p

	# Görsel ipucu
	if sprite:
		if p == Phase.SOLID:
			sprite.modulate = Color(1,1,1,1)
			sprite.scale = Vector2(1, 1)
		elif p == Phase.LIQUID:
			sprite.modulate = Color(0.6,0.8,1,1)
			sprite.scale = Vector2(4, .2)
		elif p == Phase.GAS:
			sprite.modulate = Color(1,1,1,0.65)
			sprite.scale = Vector2(1, 1)

	# Çarpışma maskesi ve snap
	if p == Phase.GAS:
		set_collision_mask_value(1, false)   # zemini görmez
		floor_snap_length = 0.0
		if was_on_floor and velocity.y >= 0.0:
			velocity.y = -60.0               # kopma itkisi
	else:
		set_collision_mask_value(1, true)    # zemini gör
		floor_snap_length = 6.0

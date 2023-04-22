extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 50.0
const JUMP_VELOCITY = -400.0

# Variables for hp management
@export var max_hp = 5
@onready var current_hp = max_hp

# Reference to sprite and enum of different frames
@onready var sprite = $Sprite2D
enum {DEFAULT_SPRITE, ATTACK_SPRITE, AIR_SPRITE}
# Animation player
@onready var anim = $AnimationPlayer

# Timer
@onready var timer = $Timer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if timer.is_stopped(): # prioritize attack sprite
			sprite.frame = AIR_SPRITE # animate jump/fall
		velocity.y += gravity * delta
	elif timer.is_stopped(): # prioritize attack sprite:
		sprite.frame = DEFAULT_SPRITE # animate default on-floor
	

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x += direction * ACCEL # accelerate
		velocity.x = clampf(velocity.x, -SPEED, SPEED) # cap out at speed
		sprite.flip_h = true if direction < 0 else false # flip sprite horizontally depending on direction
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL) # if no movement inputs received, slow down
	
	if Input.is_action_just_pressed("attack") and timer.is_stopped():
		sprite.frame = ATTACK_SPRITE
		timer.start()

	move_and_slide()

func take_damage(damage):
	anim.play("take_damage")
	current_hp -= damage
	if current_hp < 0:
		die()

func die():
	print("skullemoji lmao")
	# reload the current scene
	get_tree().change_scene_to_file("res://Death/DeathScene.tscn")

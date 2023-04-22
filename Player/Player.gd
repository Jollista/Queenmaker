extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 50.0
const JUMP_VELOCITY = -400.0

# Variables for hp management
@export var max_hp = 5
@onready var current_hp = max_hp
signal health_changed

# Variables for attacking
@export var damage = 2
# Attack range and collider
@onready var attack_range = $AttackRange
@onready var attack_collider = $AttackRange/CollisionShape2D
var bodies_list = []

# Reference to sprite and enum of different frames
@onready var sprite = $Sprite2D
enum {DEFAULT_SPRITE, ATTACK_SPRITE, AIR_SPRITE}
# Animation player
@onready var anim = $AnimationPlayer

# Audio
@onready var audio = $AudioStreamPlayer2D
@export var attack_sfx = AudioStream.new()
@export var damage_sfx = attack_sfx
@export var jump_sfx = attack_sfx

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
		velocity.y = JUMP_VELOCITY # update velocity
		# play jump sound effect
		audio.set_stream(jump_sfx)
		audio.play()

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x += direction * ACCEL # accelerate
		velocity.x = clampf(velocity.x, -SPEED, SPEED) # cap out at speed
		flip(direction) # flip if needed
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL) # if no movement inputs received, slow down
	
	if Input.is_action_just_pressed("attack") and timer.is_stopped():
		attack()

	move_and_slide()

# set player to face a given direction
func flip(direction):
	if direction < 0: # if going left
		sprite.flip_h = true # face left
		attack_collider.position.x = -abs(attack_collider.position.x) # ensure position is negative/left
	else:
		sprite.flip_h = false # face right
		attack_collider.position.x = abs(attack_collider.position.x) # ensure position is positive/right

# reduce current_hp by a given amount of damage, and check if dead (hp <= 0)
func take_damage(damage):
	# play damage sound effect
	audio.set_stream(damage_sfx)
	audio.play()
	anim.play("take_damage") # animate taking damage
	current_hp -= damage # reduce hp
	if current_hp <= 0: # check for death
		die()
	
	health_changed.emit() # emit signal if not dead

func die():
	print("skullemoji lmao")
	# reload the current scene
	get_tree().change_scene_to_file("res://Death/DeathScene.tscn")

# attack!
func attack():
	# play attack sound effect
	audio.set_stream(attack_sfx)
	audio.play() 
	sprite.frame = ATTACK_SPRITE # animate
	timer.start() # start cooldown
	
	# everything in range takes damage if able
	for body in bodies_list:
		if body.has_method("take_damage"):
			body.take_damage(damage)

# Keep bodies_list up to date with bodies in attack_range
func _on_attack_range_body_entered(body):
	if body.name != "Player": # ensure player doesn't get added to own bodies_list
		bodies_list.append(body)
func _on_attack_range_body_exited(body):
	bodies_list.erase(body)

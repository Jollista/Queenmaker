extends CharacterBody2D

var bodies_list = []

# movement
@export var speed = 50
var direction = -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# raycast for checking if about to walk off ledge
@onready var edge_check = $EdgeCheck

# Variables for hp management
@export var max_hp = 5
@onready var current_hp = max_hp
# damage dealt with attack
@export var damage = 1

# hitbox collision shape
@onready var hitbox = $CollisionShape2D
# attack range area2d
@onready var attack_range = $AttackRange
@onready var attack_collider = $AttackRange/CollisionShape2D

# sprite
@onready var sprite = $Sprite2D
enum {DEFAULT_SPRITE, ATTACK_SPRITE}
# anim
@onready var anim = $AnimationPlayer

# Audio
@onready var audio = $AudioStreamPlayer2D
@export var attack_sfx = AudioStream.new()
@export var damage_sfx = attack_sfx

# Timer for attack
@onready var timer = $Timer
@export var telegraph_delay = 0.3
@export var attack_duration = 0.5

var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# handle falling
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# determine action
	if not attacking: # if not attacking
		if bodies_list.is_empty(): # and bodies_list is empty
			patrol(delta) # just patrol
		elif timer.is_stopped(): # else, if bodies_list is not empty and timer is stopped, contains Player
			attack(bodies_list[0]) # attack 'em!
	
	move_and_slide() # update movement

# on body entered attack range
func _on_attack_range_body_entered(body):
	if body.name == "Player": # if body is player
		attack(body) # attack player
		bodies_list.append(body) # add player to bodies list

# on body exited, remove it if it's in bodies_list
func _on_attack_range_body_exited(body):
	if body in bodies_list:
		bodies_list.erase(body)

# basic patrol, just walk around until something wanders into attack range
func patrol(delta):
	if is_on_wall() or is_at_edge():
		turn()
	
	velocity.x = direction * speed # move
	move_and_slide() # update movement

# returns true if at the edge of a platform, else false
func is_at_edge():
	return not edge_check.is_colliding()

# turns the drone around
func turn():
	sprite.flip_h = !sprite.flip_h # flip sprite
	attack_collider.position.x = -attack_collider.position.x # flip attack range
	edge_check.position.x = -edge_check.position.x # flip edge_check
	direction = -direction # change direction


# attack and deal damage to things within range
func attack(body):
	# play attack sound effect
	audio.set_stream(attack_sfx)
	audio.play()
	attacking = true # set attacking to true
	sprite.frame = ATTACK_SPRITE # animate attack
	timer.start(telegraph_delay) # start timer
	await timer.timeout # wait
	
	if body.has_method("take_damage") and body in bodies_list: # if body can take damage and is still in area
		print("Ow! ", damage, " damage!")
		body.take_damage(damage) # deal damage to body
	
	timer.start(attack_duration) # start timer
	await timer.timeout # wait
	attacking = false # reset attacking to false
	sprite.frame = DEFAULT_SPRITE # reset sprite

# reduce current_hp by a given amount of damage, and check if dead (hp <= 0)
func take_damage(damage):
	# play attack sound effect
	audio.set_stream(attack_sfx)
	audio.play()
	anim.play("take_damage") # animate
	current_hp -= damage # reduce hp
	if current_hp <= 0: # check for death
		die()

func die():
	queue_free()

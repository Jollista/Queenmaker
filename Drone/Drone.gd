extends CharacterBody2D

var bodies_list = []

# movement
@export var speed = 50
var direction = -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	pass

# turns the drone around
func turn():
	sprite.flip_h = true # flip sprite
	attack_collider.position.x = -attack_collider.position.x # flip attack range
	direction = -direction # change direction


# attack and deal damage to things within range
func attack(body):
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

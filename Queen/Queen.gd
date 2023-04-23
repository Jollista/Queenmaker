extends RigidBody2D

@export var current_hp = 18 # 3 * player's damage (2)

# Timer
@onready var timer = $Timer

# FLUFF
# audio
@onready var audio = $AudioStreamPlayer2D
@export var attack_sfx = AudioStream.new()
@export var damage_sfx = attack_sfx

# anim
@onready var anim = $AnimationPlayer

# Borders
@export var left_border = -1 # left edge of boss arena
@export var right_border = 1 # right edge of boss arena
@export var top_border = 1 # top border of boss arena
@export var center = Vector2.ZERO # center of boss arena

# !! ATTACK OBJECTS !!
# Red kill ya always, blue kill ya if you're movin'
# reference to moving_spike tscn
var MovingSpike = preload("res://Objects/moving_spike.tscn")

# emitted when attack pattern finishes
signal attack_ended

func start_boss_fight():
	print("Makin' it rain")
	make_it_rain()

# reduce current_hp by a given amount of damage, and check if dead (hp <= 0)
func take_damage(damage):
	# play attack sound effect
	audio.set_stream(damage_sfx)
	audio.play()
	anim.play("take_damage") # animate
	current_hp -= damage # reduce hp
	if current_hp <= 0: # check for death
		die()

func die():
	queue_free()
	# transition to end cutscene

### ATTACK OBJECT CREATION ###
# creates a spike that moves
func create_moving_spike(spike_position=Vector2(450,0), spike_scale=Vector2(1,10), speed=10, direction=-1, vertical=false):
	# create new MovingSpike instance
	var spike_instance
	spike_instance = MovingSpike.instantiate()
	
	# initialize it
	spike_instance.position = spike_position
	spike_instance.apply_scale(spike_scale)
	spike_instance.speed = speed
	spike_instance.direction = direction
	spike_instance.vertical = vertical
	
	# add spike_instance to scene
	get_parent().call_deferred("add_child", spike_instance)
	
	# return spike_instance
	return spike_instance

### ATTACK PATTERNS ###
# summon vertical and horizontal lasers to hit all 9 squares of the play area
func make_it_rain():
	# reference to spike_instance for signals
	var spike_instance
	
	spike_instance = create_moving_spike(Vector2(center.x, top_border), Vector2(10,1), 10, 1, true)
	
	# wait for spike_instance to be deleted
	await spike_instance.tree_exited
	
	# emit signal
	attack_ended.emit()

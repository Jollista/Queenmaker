extends RigidBody2D

@export var current_hp = 18 # 3 * player's damage (2)

# FLUFF
# audio
@onready var audio = $AudioStreamPlayer2D
@export var attack_sfx = AudioStream.new()
@export var damage_sfx = attack_sfx

# anim
@onready var anim = $AnimationPlayer

func start_boss_fight():
	pass

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

# ATTACK PATTERNS

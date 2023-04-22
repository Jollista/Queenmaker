extends Node2D

# Blackout sprites
@onready var b0 = $Blackout0
@onready var b1 = $Blackout1
@onready var b2 = $Blackout2
@onready var b3 = $Blackout3

# Timer
@onready var timer = $Timer
@export var delay = 5

# Audio player
@onready var audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(1)
	await timer.timeout
	audio.play()
	
	# reveal panel 0
	b0.visible = false
	timer.start(delay)
	await timer.timeout
	audio.play()
	
	# reveal panel 1
	b1.visible = false
	timer.start(delay)
	await timer.timeout
	audio.play()
	
	# reveal panel 2
	b2.visible = false
	timer.start(delay)
	await timer.timeout
	audio.play()
	
	# reveal panel 3
	b3.visible = false
	timer.start(delay)
	await timer.timeout
	audio.play()
	
	# fade out panel
	$Story.visible = false
	timer.start(delay)
	await timer.timeout
	
	# scene transition to level 1
	get_tree().change_scene_to_file("res://levels/L1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

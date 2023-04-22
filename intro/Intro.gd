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

# Text
@onready var text = $RichTextLabel
# text background
@onready var txt_bkg = $TextBackground

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(1) # start short timer
	await timer.timeout # wait
	audio.play() # play page turn
	
	# reveal panel 0
	b0.visible = false # reveal panel
	txt_bkg.visible = true # set text background to vis
	text.visible = true # set text to vis
	text.text = "Our misshapen hive, a gift from the Keeper.\n\nHe who bestowed upon us undeserved mercy." # update text
	timer.start(delay) # start timer
	await timer.timeout # wait
	audio.play() # play page turn
	
	# reveal panel 1
	b1.visible = false # reveal panel
	text.text = "Post-mortem prophets of doom rejoiced the night of the Quakes and the Floods.\n\nAdrift in endless nothing." # update text
	timer.start(delay) # start timer
	await timer.timeout # wait
	audio.play() # play page turn
	
	# reveal panel 2
	b2.visible = false # reveal panel
	text.text = "Adrift in the river, a plague took hold of the Queen. \n\nSoon her madness began to spread." # update text
	timer.start(delay) # start timer
	await timer.timeout # wait
	audio.play() # play page turn
	
	# reveal panel 3
	b3.visible = false # reveal panel
	text.text = "The Queendom on its deathbed, young Ezekiel is chosen; sole brother of sisters.\n\nHe seeks the Princess' egg, a new monarch to crown. "
	timer.start(delay) # start timer
	await timer.timeout # wait
	audio.play() # play page turn
	
	# fade out panel
	$Story.visible = false # set panel to invis
	txt_bkg.visible = false # set text background to invis
	text.visible = false # set text to invis
	timer.start(delay) # start short timer
	await timer.timeout # wait
	
	# scene transition to level 1
	get_tree().change_scene_to_file("res://levels/L1.tscn")

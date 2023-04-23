extends Node2D

# reference to queen
@onready var queen = $Queen
# reference to audiostream player for music
@onready var music = $AudioStreamPlayer
@export var ambient_music = AudioStream.new()
@export var boss_music = ambient_music

func _ready():
	# play ambient music
	music.set_stream(ambient_music)
	music.play()

# manage border crossing for arena
func _on_border_trigger_border_crossed(tag):
	if tag == "boss_arena":
		# play boss music
		music.set_stream(boss_music)
		music.play()
		
		# start boss fight
		queen.start_boss_fight()

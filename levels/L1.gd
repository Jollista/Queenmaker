extends Node2D

# reference to queen
@onready var queen = $Queen

# manage border crossing for arena
func _on_border_trigger_border_crossed(tag):
	if tag == "boss_arena":
		queen.start_boss_fight()

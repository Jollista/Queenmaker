extends Node2D


func _on_timer_timeout():
	# scene transition to level 1
	get_tree().change_scene_to_file("res://levels/L1.tscn")

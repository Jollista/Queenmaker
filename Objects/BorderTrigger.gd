extends Area2D

@export var tag = "" # tag used for border identification
signal border_crossed(tag)

# emit signal when player crosses border
func _on_body_entered(body):
	if body.name == "Player":
		print("border crossed")
		emit_signal("border_crossed", tag)
		queue_free() # remove self

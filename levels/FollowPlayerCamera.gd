extends Camera2D

@onready var player = get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = player.position

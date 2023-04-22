extends CanvasLayer

@onready var player = get_parent().get_node("Player")
@onready var sprite = $Sprite2D

func _on_player_health_changed():
	sprite.frame = player.current_hp-1

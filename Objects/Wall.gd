extends RigidBody2D

@export var my_tag = ""

# activate on border trigger
func _on_border_trigger_border_crossed(tag):
	if my_tag == tag:
		visible = true
		$CollisionShape2D.set_deferred("disabled", false)

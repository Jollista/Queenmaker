extends Area2D

# damage to be dealt
var damage = 1
# speed spike moves
var speed = 10
# direction spike goes (-1 = left, 1 = right)
var direction = -1
# vertical if true, else horizontal
var vertical = false
#borders
var left_border = -3880
var right_border = 3880

# if mortal, take damage
func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage(damage)

# constantly move in a given horizontal direction (left by default)
func _physics_process(_delta):
	# used to check bounds for queue_free
	var bounds_check
	
	# if vertical, move vertically
	if vertical:
		bounds_check = position.y
		position += Vector2(0, speed*direction)
	else: # move horizontally
		bounds_check = position.x
		position += Vector2(speed*direction, 0)
	
	# if headed out of bounds and never coming back
	if (bounds_check < left_border and direction < 0) or (bounds_check > right_border and direction > 0):
		queue_free()

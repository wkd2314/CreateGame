extends KinematicBody2D

var velocity = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MAX_SPEED = 180
const ACCELERATION = 1500
const FRICTION = 400

# Called when the node enters the scene tree for the first time.

func _physics_process(delta): #called every single tick physics update
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() # for diagonal moves
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_collide(velocity * delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

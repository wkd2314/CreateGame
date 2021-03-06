extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 1000
export var MAX_SPEED = 100
export var ROLL_SPEED = 135
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats # setted it as singleton object in ProjectSetting Autoload

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
# dollar sign for getting access to child of tree node (Player)

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

# _physics_process #called every single tick physics update. delta is constant
func _process(delta): # called every frame. delta is not constant
	match state:
		MOVE: 
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() # for diagonal moves
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position" , input_vector)
		animationTree.set("parameters/Attack/blend_position" , input_vector)
		animationTree.set("parameters/Roll/blend_position" , input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE
	
func attack_animation_finished():
	state = MOVE


func _on_Hurtbox_area_entered(area):
	if(area.collision_mask == 4):
		stats.health -= 1
		hurtbox.start_invincibility(0.8)
		hurtbox.create_hit_effect()
		var playerHurtSound = PlayerHurtSound.instance()
		get_tree().current_scene.add_child(playerHurtSound) #world


func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

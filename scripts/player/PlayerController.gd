"""
TO DO:
	- Lag Compensation (by sending velocity)
	- Smoothing stop (using lerp)
	- Dashing ability
	
"""

# DOES ANIMATION AND PLAYER MOVEMENT
extends KinematicBody2D


var speed = 8000
var friction = .3
var dash_multiplier = 20

var dashing = false

onready var info = $PlayerInfo

puppet var velocity = Vector2.ZERO
puppet var pposition = Vector2.ZERO setget set_pposition

func _ready():
	if is_network_master():
		$PlayerCamera.current = true

func _physics_process(delta):
	if is_network_master():
		var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
		var input_y = Input.get_action_strength("down") - Input.get_action_strength("up")
		
		if input_x != 0 or input_y != 0:
			velocity = Vector2(input_x, input_y).normalized() * speed * delta
		else: 
			velocity = lerp(velocity, Vector2.ZERO, friction)
		
		if not dashing and Input.is_action_just_pressed("dash"):
			dash()
			
		move_and_slide(velocity)
		
	# ALL CLIENTS SHOULD DO ANIMATION STUFF
	do_animation()

func dash():
	#dashing = true
	velocity *= dash_multiplier
	#yield(get_tree().create_timer(1), "timeout")
	#dashing = false

func do_animation():
	if velocity == Vector2.ZERO:
		$AnimatedSprite.play("idle")
	elif velocity.x > 0:
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true


# NETWORK STUFF
func set_pposition(pos):
	pposition = pos
	$Tween.interpolate_property(self, "position", position, pposition, 0.1)
	$Tween.start()

func _on_SyncTimer_timeout():
	if is_network_master():
		rset_unreliable("pposition", position)
		rset_unreliable("velocity", velocity)

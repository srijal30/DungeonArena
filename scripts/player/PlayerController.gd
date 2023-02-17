"""
TO DO:
	- Lag Compensation (by sending velocity)
	- Dashing ability animation (ghost frames)
	- CLEAN UP KNOCKBACK
	- Let attacker choose knockback?
"""

# DOES ANIMATION AND PLAYER MOVEMENT
extends KinematicBody2D

var knockback_strength = 800
var speed = 8000
var friction = .3

var dash_multiplier = 3.5
var dash_frames = 0
var dash_delay = 0.4
var can_dash = true

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
		if dash_frames > 0:
			dash_frames -= 1
		elif input_x != 0 or input_y != 0:
			velocity = Vector2(input_x, input_y).normalized() * speed * delta
		else:
			if velocity.length() > 1:
				velocity = lerp(velocity, Vector2.ZERO, friction)
			# sets velocity to zero once reached threshold
			else:
				velocity = Vector2.ZERO
		if Input.is_action_just_pressed("dash") and dash_frames == 0 and can_dash:
			dash()
		move_and_slide(velocity)
		
	# ALL CLIENTS SHOULD DO ANIMATION STUFF
	do_animation()

func dash():
	dash_frames = 10
	# ensure that velocity doesnt get too high
	velocity *= dash_multiplier
	velocity.x = clamp(velocity.x, -speed*dash_multiplier, speed*dash_multiplier)
	velocity.y = clamp(velocity.y, -speed*dash_multiplier, speed*dash_multiplier)
	# experimenting with dash delay
	can_dash = false
	yield(get_tree().create_timer(dash_delay), "timeout")
	can_dash = true
	
# STUB: test this
# not sure if this works
func knockback(src_pos):
	velocity = Vector2(src_pos.x-position.x, src_pos.y-position.y).normalized() * -knockback_strength

func do_animation():
	# determine orientation
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	# determine walk run dash
	if velocity.length() == 0:
		$AnimatedSprite.play("idle")
	elif dash_frames > 0:
		# have particles for the dash
		pass
	else:
		$AnimatedSprite.play("run")
		
	
# NETWORK STUFF
func set_pposition(pos):
	pposition = pos
	$Tween.interpolate_property(self, "position", position, pposition, 0.1)
	$Tween.start()

func _on_SyncTimer_timeout():
	if is_network_master():
		rset_unreliable("pposition", position)
		rset_unreliable("velocity", velocity)

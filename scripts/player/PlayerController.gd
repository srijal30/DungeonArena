# DOES ANIMATION AND PLAYER MOVEMENT
extends KinematicBody2D


# constants
var speed = 8000
# GameManager should have global constants for all players

puppet var velocity = Vector2.ZERO
puppet var pposition = Vector2.ZERO setget set_pposition

func _ready():
	if is_network_master():
		$PlayerCamera.current = true

func _physics_process(delta):
	if is_network_master():
		var vel_x = Input.get_action_strength("right") - Input.get_action_strength("left")
		var vel_y = Input.get_action_strength("down") - Input.get_action_strength("up")
		velocity = Vector2(vel_x, vel_y).normalized() * speed * delta
		move_and_slide(velocity)
		
	# ALL CLIENTS SHOULD DO ANIMATION STUFF
	do_animation()

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

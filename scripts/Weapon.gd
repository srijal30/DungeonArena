"""
TO DO:
	- Change weapon type functionality
"""

extends Node2D

var weapon_damage : float = 1
var attacking: bool = false

onready var parent = get_parent()

func _process(_delta): 
	# allow only network master to do this
	if is_network_master() and Input.is_action_just_pressed("attack"):
		if not attacking:
			rpc("point_to", get_global_mouse_position())
			rpc("attack")

puppetsync func point_to(pos):
	look_at(pos)

puppetsync func attack():
	attacking = true
	$AnimationPlayer.play("slash")
	yield($AnimationPlayer, "animation_finished")
	attacking = false

# ONLY NETWORK MASTER COMMITS THE DAMAGE	
func _on_Hitbox_body_entered(body):
	if body.is_in_group("character") and is_network_master() and body != parent and attacking:
		print("weapon pos: ", position)
		body.info.rpc("modify_health", -weapon_damage, get_parent().position)

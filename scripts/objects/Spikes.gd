extends Area2D

enum state {
	ON, 
	OFF
}

puppet var cur_state = state.OFF

export var spike_damage: float = .5

# STUB: clients that just joined will not be synced with the spike traps
func turn_on():
	cur_state = state.ON
	$AnimatedSprite.play("on")
	
	# MAKE THIS MORE GENERAL (NOT JUST FOR PLAYERS)
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player") and is_network_master():
			body.info.rpc("modify_health", -spike_damage, position, 1.5, "")

func turn_off():
	cur_state = state.OFF
	$AnimatedSprite.play("off")

func _on_Spike_body_entered(body):
	if body.is_in_group("player") and cur_state == state.ON and is_network_master():
		body.info.rpc("modify_health", -spike_damage, position, 1.5, "")


func _sync(id):
	rset_id(id, "cur_state", cur_state)
	rpc_id(id, "sync_gfx")

puppet func sync_gfx():
	if cur_state == state.ON:
		$AnimatedSprite.play("on")
	else:
		$AnimatedSprite.play("off")

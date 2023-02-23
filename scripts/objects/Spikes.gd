extends Node2D

enum state {
	ON, 
	OFF
}

var cur_state = state.OFF

export var spike_time: float = 5
export var spike_damage: float = .5

func _ready():
	if is_network_master():
		$Timer.wait_time = spike_time
		$Timer.start()

# STUB: clients that just joined will not be synced with the spike traps
puppetsync func turn_on():
	cur_state = state.ON
	$AnimatedSprite.play("on")
	
	# MAKE THIS MORE GENERAL (NOT JUST FOR PLAYERS
	var bodies = $Hitbox.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player") and is_network_master():
			body.info.rpc("modify_health", -spike_damage, position, 1)

puppetsync func turn_off():
	cur_state = state.OFF
	$AnimatedSprite.play("off")

func _on_Timer_timeout():
	if is_network_master():
		if cur_state == state.OFF:
			rpc("turn_on")
		else:
			rpc("turn_off")

# STUB: better way for player to take damage
func _on_Hitbox_body_entered(body):
	if body.is_in_group("player") and cur_state == state.ON and is_network_master():
		body.info.rpc("modify_health", -spike_damage, position, 1)

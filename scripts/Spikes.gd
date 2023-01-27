extends Node2D

enum state {
	ON, 
	OFF
}
var cur_state = state.OFF

export var spike_time: float = 5
export var spike_damage: int = 10


func _ready():
	if is_network_master():
		$Timer.wait_time = spike_time
		$Timer.start()

puppetsync func turn_on():
	cur_state = state.ON
	$AnimatedSprite.play("on")

puppetsync func turn_off():
	cur_state = state.OFF
	$AnimatedSprite.play("off")


func _on_Timer_timeout():
	if is_network_master():
		if cur_state == state.OFF:
			rpc("turn_on")
		else:
			rpc("turn_off")
		
func _on_Hitbox_body_entered(body):
	if body.is_in_group("player") and cur_state == state.ON:
		body.take_damage(spike_damage)

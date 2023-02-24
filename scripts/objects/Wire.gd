extends Area2D

puppet var activated : bool = false setget toggle
puppet var power_sources : int = 0

func add_power():
	power_sources += 1
	if power_sources > 0 and not activated:
		toggle(true)
	
func remove_power():
	power_sources = max(0, power_sources-1)
	if power_sources == 0 and activated:
		toggle(false)
		
func toggle(new_val: bool):
	activated = new_val
	for area in get_overlapping_areas():
		if area.is_in_group("contraption"):
			if activated:
				area.turn_on()
			else:
				area.turn_off()
	
	
func _sync(id):
	rset_id(id, "activated", activated)
	rset_id(id, "power_sources", power_sources)

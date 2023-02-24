extends Area2D

puppet var activated : bool = false

var off_rect : Rect2 = Rect2(80, 192.5, 16, 16)
var on_rect : Rect2 = Rect2(96, 192.5, 16, 16)

# in this case it is toggle
remotesync func interact():
	activated = not activated
	# change sprite
	if activated:
		$Sprite.region_rect = on_rect
	else:
		$Sprite.region_rect = off_rect
	
	# game logic
	for area in get_overlapping_areas():
		if area.is_in_group("wire"):
			if activated:
				area.add_power()
			else:
				area.remove_power()


func _sync(id):
	rset_id(id, "activated", activated)
	print("master of the lever: " + str(get_network_master()))
	rpc_id(id, "sync_gfx")

remotesync func sync_gyfx():
	if activated:
		$Sprite.region_rect = on_rect
	else:
		$Sprite.region_rect = off_rect

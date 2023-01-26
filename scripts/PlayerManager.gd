extends Node

var players: Array = []
var PlayerScene = preload("res://scenes/player/Player.tscn")

func remove_player(id: int):
	players.erase(id)
	
	# IDK IF THIS WILL WORK?
	get_node(str(id)).queue_free() 	# STUB: remove the child node
	
	if get_tree().get_network_unique_id() == id:
		pass


func create_player(id: int):
	players.append(id)
	var new_player = PlayerScene.instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id) # this should automatically set master properly?
	add_child(new_player)


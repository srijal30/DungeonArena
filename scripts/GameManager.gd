extends Node2D

# PLAYER STUFF
var players: Array = []
var PlayerScene = preload("res://scenes/player/Player.tscn")


# GAME STUFF
var TestScene = preload("res://scenes/levels/Test.tscn")


func create_level():
	var test_level = TestScene.instance()
	add_child(test_level)


func remove_player(id: int):
	players.erase(id)
	# IDK IF THIS WILL WORK?
	get_node(str(id)).queue_free() 	# STUB: remove the child node
	if get_tree().get_network_unique_id() == id:
		#STUB: return to lobby
		pass


func create_player(id: int):
	players.append(id)
	var new_player = PlayerScene.instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id) # this should automatically set master properly?
	add_child(new_player)

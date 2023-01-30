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
	# STUB: remove the player
	players.erase(id)
	get_node(str(id)).queue_free()
	
	#STUB: return to lobby if we disconnected
	if get_tree().get_network_unique_id() == id:
		pass


remotesync func create_player(id: int, username: String):
	# create the new player
	players.append(id)
	var new_player = PlayerScene.instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id)
	
	# setup the player info
	new_player.set_username(username)
	
	# connect HUD if master
	if id == get_tree().get_network_unique_id():
		PlayerInfo.player = new_player
		PlayerInfo.start()
	
	# create the player
	add_child(new_player)

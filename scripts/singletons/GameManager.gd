# TO DO:
# make this script send all level data to newly connected clients

extends Node2D

# PLAYER STUFF
var players: Dictionary = {}
var PlayerScene = preload("res://scenes/player/Player.tscn")

# GAME STUFF
var TestScene = preload("res://scenes/levels/Test.tscn")
var currentLevel: Node2D

# STUB: sync the level too
func create_level():
	var testLevel  = TestScene.instance()
	currentLevel = testLevel
	add_child(currentLevel)


func clear_level():
	for player in players:
		remove_child(players[player])
		
	remove_child(currentLevel)


func remove_player(id: int):
	# STUB: remove the player
	players.erase(id)
	get_node(str(id)).queue_free()


remotesync func create_player(id: int, username: String):
	var new_player = PlayerScene.instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id)
	new_player.position = get_valid_spawn()
	
	# WARNING: get_node is dangerous
	new_player.get_node("PlayerInfo").set_username(username)
	
	# create the player
	players[str(id)] = new_player
	add_child(new_player)


func get_valid_spawn():
	var space_state = get_world_2d().direct_space_state
	var random_point = Vector2((randi()%50-25)*16, (randi()%50-25)*16)
	var result = space_state.intersect_point(random_point)
	while len(result) != 0:
		random_point = Vector2(randi()%(50*16)-(25*16), randi()%(50*16)-(25*16))
		result = space_state.intersect_point(random_point)
	return random_point

extends Node

var PORT : int = 55555 # 58008
var MAX_PLAYERS : int = 10
var username: String

func _ready():
	randomize()
	# server & client signals
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")	
	# client only signals
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")
	
	# will not run process until peer created
	set_process(false)

func _process(delta):
	if get_tree().is_network_server():
		var server = get_tree().network_peer
		if server.is_listening():
			server.poll()
	else:
		var client = get_tree().network_peer
		var status = client.get_connection_status()
		if status == NetworkedMultiplayerPeer.CONNECTION_CONNECTED or status == NetworkedMultiplayerPeer.CONNECTION_CONNECTING:
			client.poll()


# UNIQUE SERVER FUNCTIONALITY
# ...
# TO DO:
# ADD A FUNCTION THAT SYNCS ALL CLIENTS WHEN THEY JOIN

func create_server() -> void:
	print("server created")
	
	var server = WebSocketServer.new()
	server.listen(PORT, PoolStringArray(), true)
	get_tree().network_peer = server
	set_process(true)
	
	# STUB: setup the level
	GameManager.create_level()


func create_client(ip: String, name: String) -> void:
	print("client created")
	
	var client = WebSocketClient.new()
	var url = "ws://" + ip + ":" + str(PORT)
	var error = client.connect_to_url(url, PoolStringArray(), true)
	get_tree().network_peer = client
	set_process(true)
	
	# WARNING: move create level somewhere else just in case not connected properly
	# STUB: setup the level (right now not fully synced (spikes for e.g))
	username = name # THIS CAN BE WAY CLEANER ;(
	GameManager.create_level()


# SIGNALS
func _peer_connected(id: int) -> void:
	print("peer with id: " + str(id) + " connected")
	# if not server, then send our player to newly connected client
	if not get_tree().is_network_server():
		var netId = get_tree().get_network_unique_id()
		GameManager.rpc_id(id, "create_player", netId, username)

func _peer_disconnected(id: int) -> void:
	# STUB: remove the player
	print("peer with id: " + str(id) + " disconnected")
	if id != 1:
		GameManager.remove_player(id)

func _connected_to_server() -> void:
	print("connected to the server!")
	# STUB: create the player for yourself & server
	var netId = get_tree().get_network_unique_id()
	GameManager.create_player(netId, username) # create player for ourself

func _connection_failed() -> void:
	# STUB: return to lobby & error message
	print("connection attempt to server failed!")
	GameManager.clear_level() #?

func _server_disconnected() -> void:
	# STUB: return to lobby
	print("disconnected from the server!")
	GameManager.clear_level() #?

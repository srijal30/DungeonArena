extends Node

var PORT : int = 58008
var MAX_PLAYERS : int = 10

func _ready():
	# connect the networking signals
	# server & client
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")	
	# client only
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")


func create_server() -> void:
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer


func create_client(ip: String) -> void:
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, PORT)
	get_tree().network_peer = peer

# UNIQUE SERVER FUNCTIONALITY
# ...

# SIGNALS
func _peer_connected(id: int) -> void:
	print("peer with id: " + str(id) + " connected")
	if id != 1:
		PlayerManager.create_player(id)

func _peer_disconnected(id: int) -> void:
	# STUB: remove the player
	print("peer with id: " + str(id) + " disconnected")
	if id != 1:
		PlayerManager.remove_player(id)

func _connected_to_server() -> void:
	print("connected to the server!")
	# STUB: create the player for yourself
	PlayerManager.create_player(get_tree().get_network_unique_id())

func _connection_failed() -> void:
	# STUB: return to lobby & error message
	print("connection attempt to server failed!")

func _server_disconnected() -> void:
	# STUB: return to lobby
	print("disconnected from the server!")

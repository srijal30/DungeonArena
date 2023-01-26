extends Node

func _ready():
	# connect the networking signals
	# server & client
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")	
	# client only
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")


func _peer_connected(id: int) -> void:
	pass
		
func _peer_disconnected(id: int) -> void:
	pass

func _connected_to_server() -> void:
	pass

func _connection_failed() -> void:
	pass

func _server_disconnected() -> void:
	pass


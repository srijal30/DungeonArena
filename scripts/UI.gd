extends Control

onready var input_ip  = $Lobby/InputIP
onready var input_username = $Lobby/InputUsername

func _ready():
	# connect network signals
	get_tree().connect("server_disconnected", $Lobby, "show")
	get_tree().connect("connection_failed", $Lobby, "show")

func _on_Host_button_up() -> void:
	print("this is the server")
	print(IP.get_local_addresses()[3])
	Network.create_server()
	$Lobby.hide()

func _on_Join_button_up() -> void:	
	if not valid_ip(input_ip.text):
		print("enter a valid IP address!")
	elif input_username.text == "":
		print("please enter a valid username")
	else:
		print("this is the client")
		Network.create_client(input_ip.text, input_username.text)
		$Lobby.hide()

# STUB
func valid_ip(ip: String) -> bool:
	return ip != ""	

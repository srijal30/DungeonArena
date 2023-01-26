extends Control

onready var ip_input = $VBoxContainer/InputIP
onready var username_input = $VBoxContainer/InputUsername

func _on_Host_button_up() -> void:
	print("this is the server")
	print(IP.get_local_addresses()[3])
	Network.create_server()
	hide()

func _on_Join_button_up() -> void:	
	if not valid_ip(ip_input.text):
		print("enter a valid IP address!")
	elif username_input.text == "":
		print("please enter a valid username")
	else:
		print("this is the client")
		Network.create_client(ip_input.text)
		hide()
# STUB
func valid_ip(ip: String) -> bool:
	return ip != ""	

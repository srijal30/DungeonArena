extends Control

onready var ip_input = $VBoxContainer/InputIP

func _on_Host_button_up() -> void:
	Network.create_server()
	print(IP.get_local_addresses())
	hide()

func _on_Join_button_up() -> void:	
	if valid_ip(ip_input.text):
		Network.create_client()
		hide()
	else:
		print("Not valid IP!")

# STUB
func valid_ip(ip: String) -> bool:
	return ip != ""

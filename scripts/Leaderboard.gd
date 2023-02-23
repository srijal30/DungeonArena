extends VBoxContainer

var entry = preload("res://scenes/LeaderboardEntry.tscn")

func add_entry(username: String, kills: int) -> void:
	var new_entry = entry.instance()
	var container = new_entry.get_node("Container")
	container.get_node("Name").text = username
	container.get_node("Kills").text = str(kills)
	add_child(new_entry)
	
func clear_entries() -> void:
	for node in get_children():
		node.queue_free()

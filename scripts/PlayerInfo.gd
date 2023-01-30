extends Node

var HUDScene : PackedScene = preload("res://scenes/HUD.tscn")
var HUD: Node

var player : Node
var username: String

var health: int

# SPAWN THE HUD
func start():
	HUD = HUDScene.instance()
	get_node("/root").add_child(HUD)

# TAKE DAMAGE

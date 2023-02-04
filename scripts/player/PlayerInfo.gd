extends Node

var HUDScene : PackedScene = preload("res://scenes/HUD.tscn")
var HUD: Node

var player : Node
var username: String

# default values
var maxHearts: float = 5
var currentHearts: float = 3

func _ready():
	if is_network_master():
		HUD = HUDScene.instance()
		HUD.info = self
		add_child(HUD)
		$HealthBar.hide()


func _process(_delta):
	if Input.is_action_just_pressed("toggle_info"):
		self.visible = not self.visible
	if not is_network_master():
		$HealthBar/Health.rect_size.x = (currentHearts/maxHearts) * 20

# CONTROLLER FUNCTIONS

func set_username(name: String):
	$Username.text = name


# NETWORK FUNCTIONS


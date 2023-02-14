extends Node

var HUDScene : PackedScene = preload("res://scenes/HUD.tscn")
var HUD: Node

onready var material = get_node("../AnimatedSprite").get_material()
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

# can only get called by master
func flash():
	material.set_shader_param("flash_modifer", 1.0)
	yield(get_tree().create_timer(.1), "timeout")
	material.set_shader_param("flash_modifer", 0.0)
	
func set_username(name: String):
	$Username.text = name


# NETWORK FUNCTIONS
remotesync func modify_health(hearts: float, src_pos) -> void:
	if hearts < 0:
		flash()
	currentHearts = clamp(currentHearts + hearts, 0, maxHearts)
	# check if knockback should be applied
	if src_pos != null:
		get_parent().knockback(src_pos)

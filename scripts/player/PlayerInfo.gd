extends Node

var HUDScene : PackedScene = preload("res://scenes/HUD.tscn")
var HUD: Node

onready var material = get_node("../AnimatedSprite").get_material()
onready var player = get_parent()

var username: String
var maxHearts: float = 5
var currentHearts: float = 3
var invincible: bool = false

func _ready():
	if is_network_master():
		HUD = HUDScene.instance()
		HUD.info = self
		add_child(HUD)

func _process(_delta):
	if Input.is_action_just_pressed("toggle_info"):
		$Username.visible = not $Username.visible
		
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
	# check if damage is being done
	if hearts < 0:
		flash()
		# check if knockback should be applied
		if src_pos != null:
			player.knockback(src_pos)	
	# skip if invincible
	if hearts < 0 and invincible:
		return
	else:
		currentHearts = clamp(currentHearts + hearts, 0, maxHearts)
	# check for death
	if currentHearts == 0:
		# TO DO: create a death function 
		player.set_process(false)
		player.visible = false
		if is_network_master():
			HUD.activate_death_timer()

remotesync func finish_death():
	# Set spawning systems later
	player.position = Vector2(0, 0)
	currentHearts = maxHearts
	player.set_process(true)
	player.visible = true

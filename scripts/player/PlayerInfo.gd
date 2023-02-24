extends Node2D

var HUDScene : PackedScene = preload("res://scenes/ui/HUD.tscn")
var HUD: Node

onready var sprite_material = get_node("../AnimatedSprite").get_material()
onready var player = get_parent()

var closest : Node = null
var highlight : Shader = preload("res://assets/shaders/highlight.tres")
var highlightMaterial : ShaderMaterial = ShaderMaterial.new()

var username: String
var kills: int = 0

var maxHearts: float = 6
var currentHearts: float = 6

var invincible: bool = false
var dead: bool = false

func _ready():
	highlightMaterial.set_shader(highlight)
	if is_network_master():
		HUD = HUDScene.instance()
		HUD.info = self
		add_child(HUD)

func _process(_delta):
	if Input.is_action_just_pressed("toggle_info"):
		$Username.visible = not $Username.visible
		
	$HealthBar/Health.rect_size.x = (currentHearts/maxHearts) * 20
	
	if is_network_master():
		check_interact()

# CONTROLLER FUNCTIONS
func check_interact():
	if closest:
		closest.set_material(null)
	closest = null
	# find new closest
	for area in $InteractArea.get_overlapping_areas():
		if area.is_in_group("interact"):
			if not closest:
				closest = area
			elif position.distance_to(closest.position) > position.distance_to(area.position):
				closest = area
	# highlight the new closest
	if closest:
		closest.set_material(highlightMaterial)
	if Input.is_action_just_pressed("interact"):
		if closest:
			closest.rpc("interact")
		else:
			print("nothing to interact with!")

# can only get called by master
func flash():
	sprite_material.set_shader_param("flash_modifer", 1.0)
	yield(get_tree().create_timer(.1), "timeout")
	sprite_material.set_shader_param("flash_modifer", 0.0)
	
func set_username(name: String):
	username = name
	$Username.text = name

# NETWORK FUNCTIONS
remotesync func modify_health(hearts: float, src_pos: Vector2, knockback_mod: float, id: String) -> void:
	if dead or (hearts < 0 and invincible):
		return
	# check if damage is being done
	if hearts < 0:
		flash()
	player.knockback(src_pos, knockback_mod)
	currentHearts = clamp(currentHearts + hearts, 0, maxHearts)
	# check for death
	if currentHearts == 0:
		# check if a player killed
		if id != "":
			GameManager.increment_kills(id)
		start_death()

func start_death():
	kills = 0
	GameManager.emit_signal("leaderboard_update")
	dead = true
	player.set_physics_process(false)
	player.rotation_degrees = 90
	self.visible = false
	if is_network_master():
		HUD.activate_death_timer()

remotesync func finish_death():
	player.position = GameManager.get_valid_spawn()
	currentHearts = maxHearts
	player.set_physics_process(true)
	player.rotation_degrees = 0
	self.visible = true
	dead = false

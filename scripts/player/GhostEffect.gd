extends Node2D

export var img : Texture
export var period : int = 1  # how many frames per spawn
export var activated : bool = false

func _process(_delta):
	if activated and get_tree().get_frame() % period == 0:
		spawn_ghost(global_position)

func spawn_ghost(pos: Vector2):
	var new_ghost = Sprite.new()
	new_ghost.texture = img
	new_ghost.global_position = pos	
	var tween = Tween.new()
	new_ghost.add_child(tween)
	tween.interpolate_property(new_ghost, "modulate:a", 1.0, 0.0, 0.5, 3, 1)
	get_tree().current_scene.add_child(new_ghost)
	tween.start()
	yield(tween, "tween_completed")
	new_ghost.queue_free()

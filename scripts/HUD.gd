extends CanvasLayer

var info : Node

func _process(_delta):
	$FPSCounter.text = "FPS: " + str(Engine.get_frames_per_second())
	
	$HeartsBackground.rect_size.x = info.maxHearts * 16
	$Hearts.rect_size.x = info.currentHearts * 16

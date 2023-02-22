extends CanvasLayer

var info : Node
var deathTimerOn : bool = false
var respawnTime : int = 3

func _process(_delta):
	$FPSCounter.text = "FPS: " + str(Engine.get_frames_per_second())

#	$HeartsBackground.rect_size.x = info.maxHearts * 16
#	$Hearts.rect_size.x = info.currentHearts * 16
	
	if deathTimerOn:
		$DeathTimer/TimeLeft.text = str(stepify($DeathTimer/Timer.get_time_left(), .1))

func activate_death_timer():
	$DeathTimer.visible = true
	$DeathTimer/Timer.wait_time = respawnTime
	deathTimerOn = true
	$DeathTimer/Timer.start()

func _on_Timer_timeout():
	deathTimerOn = false
	$DeathTimer.visible = false
	info.rpc("finish_death")

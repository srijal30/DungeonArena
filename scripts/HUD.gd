extends CanvasLayer

var info : Node
var deathTimerOn : bool = false
var respawnTime : int = 3

func _ready():
	GameManager.connect("leaderboard_update", self, "update_leaderboard")

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

func update_leaderboard():
	$Leaderboard.clear_entries()
	var entries = []
	for id in GameManager.players:
		var info = GameManager.players[id].info
		var username = info.username
		var kills = info.kills
		# insertion sort
		if len(entries) == 0:
			entries.append([username, kills])
		else:
			for i in range(len(entries)+1):
				if i == len(entries):
					entries.append([username, kills])
					break
				elif kills > entries[i][1]:
					entries.insert(i, [username, kills])
					break			
	for entry in entries:
		$Leaderboard.add_entry(entry[0], entry[1])

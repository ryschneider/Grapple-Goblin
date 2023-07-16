extends AudioStreamPlayer2D

var mainTheme = preload("res://assets/SFX/RepeatingSong.wav")
var bossTheme = preload("res://assets/SFX/GameMusic.wav")

func _ready():
	pass

var offset = 0

func mute():
	volume_db = -1000
func unmute():
	volume_db = 0

func playMain():
	if stream != mainTheme:
		stream = mainTheme
		offset = 8
		play()

func playBoss():
	if stream != bossTheme:
		stream = bossTheme
		offset = 0
		play()

func _on_finished():
	play(offset)

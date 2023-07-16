extends AudioStreamPlayer2D

var mainTheme = preload("res://assets/SFX/RepeatingSong.wav")
var bossTheme = preload("res://assets/SFX/GameMusic.wav")

func _ready():
#	mainTheme.loop_mode = AudioStreamWAV.LOOP_FORWARD
#	mainTheme.loop_begin = 0
	pass

func playMain():
	if stream != mainTheme:
		stream = mainTheme
		play()

func playBoss():
	if stream != bossTheme:
		stream = bossTheme
		play()

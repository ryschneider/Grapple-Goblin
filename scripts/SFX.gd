extends AudioStreamPlayer2D

var jump = preload("res://assets/SFX/jump.wav")
var mainTheme = preload("res://assets/SFX/RepeatingSong.wav")

func _ready():
#	mainTheme.loop_mode = AudioStreamWAV.LOOP_FORWARD
#	mainTheme.loop_begin = 0

	stream = mainTheme
	play()

func playJump():
	stream = jump
	play()

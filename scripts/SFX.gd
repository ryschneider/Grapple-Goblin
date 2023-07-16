extends AudioStreamPlayer2D

var jump = preload("res://assets/SFX/jump.wav")
var button = preload("res://assets/SFX/button.wav")
var pickup = preload("res://assets/SFX/PickupItem.wav")
var hook = preload("res://assets/SFX/hook.wav")

func _ready():
	pass

func playJump():
	volume_db = -5
	stream = jump
	play()

func playButton():
	volume_db = -5
	stream = button
	play()

func playPickup():
	volume_db = 0
	stream = pickup
	play()

func inPickup():
	return stream == pickup and get_playback_position() < 1.2

func playHook():
	volume_db = -5
	stream = hook
	play()

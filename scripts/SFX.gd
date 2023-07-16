extends AudioStreamPlayer2D

var jump = preload("res://assets/SFX/jump.wav")
var button = preload("res://assets/SFX/button.wav")
var pickup = preload("res://assets/SFX/PickupItem.wav")

func _ready():
	pass

func playJump():
	stream = jump
	play()

func playButton():
	stream = button
	play()

func playPickup():
	stream = pickup
	play()

func inPickup():
	return stream == pickup and get_playback_position() < 1.2

extends Node2D

func _ready():
	toFire()

func switch(fireScene):
	if fireScene:
		toFire()
	else:
		toIce()

func toFire():
	$FireBg.show()
	$IceBg.hide()

func toIce():
	$IceBg.show()
	$FireBg.hide()
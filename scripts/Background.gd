extends Node2D

func switch(fireScene):
	if fireScene:
		toFire()
	else:
		toIce()

var wasFireScene
func _physics_process(_delta):
	if Global.isFireScene != wasFireScene:
		wasFireScene = Global.isFireScene
		if Global.isFireScene: toFire()
		else: toIce()

func toFire():
	$FireBg.show()
	$IceBg.hide()

func toIce():
	$IceBg.show()
	$FireBg.hide()

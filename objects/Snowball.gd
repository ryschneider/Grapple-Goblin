extends Node2D

var right = 1700
var left = -125
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
	if position.x > right or position.x < left:
		queue_free() 
		
func toFire():
	$FireBg.show()
	$IceBg.hide()

func toIce():
	$IceBg.show()
	$FireBg.hide()

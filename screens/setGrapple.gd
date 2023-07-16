extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.canGrapple:
		queue_free()

func _process(delta):
	if Global.canGrapple:
		queue_free()


func _on_body_entered(body):
	Global.canGrapple = true # Replace with function body.
	queue_free()


func _on_area_entered(area):
	Global.canGrapple = true # Replace with

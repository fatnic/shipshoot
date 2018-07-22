extends Area2D

func _ready():
	pass


func _on_Area2D_body_entered(body):
	
	if body.has_method("refuel"):
		body.call("refuel", 5)
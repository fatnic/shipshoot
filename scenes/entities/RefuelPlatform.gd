extends Node2D

export (int) var refuel_rate = 10

func _on_Area2D_body_entered(body):
	if body.has_method("set_refuel_rate"): body.call("set_refuel_rate", refuel_rate)

func _on_Area2D_body_exited(body):
	if body.has_method("set_refuel_rate"): body.call("set_refuel_rate", null)
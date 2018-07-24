extends Node2D

export (int) var refuel_rate = 10

func _on_Area2D_body_entered(body):
	body.set('refuelling', refuel_rate)

func _on_Area2D_body_exited(body):
	body.set('refuelling', null)
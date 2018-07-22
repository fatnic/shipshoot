extends Area2D

func _ready():
	pass


func _on_Refuel_body_entered(body):
	print(body.get_name())
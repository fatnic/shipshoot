extends Node2D

func _ready():
	pass

func _on_Ship_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)
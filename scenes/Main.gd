extends Node2D

onready var ship = preload("res://scenes/entities/Ship.tscn")

func _ready():
	spawn_ship(Vector2(get_viewport().size.x / 2, get_viewport().size.y - 50))

func spawn_bullet(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)
	
func spawn_ship(_position):
	var s = ship.instance()
	s.connect("dead", self, "spawn_ship")
	s.connect("fuel_changed", $HUD, "update_fuelbar")
	s.connect("spawn_bullet", self, "spawn_bullet")
	s.new_position = _position
	add_child(s)
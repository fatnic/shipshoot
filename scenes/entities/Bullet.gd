extends Area2D

export (int) var speed
export (float) var lifetime

var velocity = Vector2()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	velocity = _direction * speed
	
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	
func _process(delta):
	position += velocity * delta
	
	if position.x > get_viewport().size.x:
		position.x = 0
		
	if position.x < 0:
		position.x = get_viewport().size.x	


func _on_Bullet_body_entered(body):
	print("I hit " + body.get_name())
	queue_free()

func _on_Lifetime_timeout():
	queue_free()

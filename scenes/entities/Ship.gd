extends RigidBody2D

signal spawn_bullet
signal fuel_changed
signal dead

export (int) var thrust = 5
export (int) var max_speed = 80
export (int) var rotation_speed = 2

export (int) var ground_hit_velocity = 40

export (int) var max_fuel = 100
export (int) var fuel
export (int) var fuel_per_second

export (PackedScene) var Bullet

var canshoot = true
var new_position = null

func _ready():
	fuel = max_fuel
	emit_signal('fuel_changed', fuel * 100 / max_fuel)
	

func rotate_ship(direction):

	if fuel <= 0: 
		return
		
	angular_velocity = direction * rotation_speed


func _physics_process(delta):

	if Input.is_action_pressed("ui_left"):
		rotate_ship(-1)
	elif Input.is_action_pressed("ui_right"):
		rotate_ship(1)
	else:
		rotate_ship(0)

	if Input.is_action_pressed("ui_up"):
		thrust(delta)
		
	if Input.is_action_just_released("ui_up"):
		$Flames.emitting = false
		$RocketSound.stop()
		
	if Input.is_action_pressed("fire"):
		shoot()

	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed		
		
	if Input.is_key_pressed(KEY_F):
		refuel(20)
		
		
func refuel(amount):
	fuel = clamp(fuel + amount, fuel + amount, max_fuel)
	emit_signal('fuel_changed', fuel * 100 / max_fuel)
	
			
func thrust(delta):
	
	if fuel < 0: fuel = 0
	
	if fuel == 0: 
		$RocketSound.stop()
		$Flames.emitting = false
	
	if fuel > 0:
		apply_impulse(Vector2(), Vector2(0, -thrust).rotated(rotation))
		fuel -= fuel_per_second * delta
		emit_signal('fuel_changed', fuel * 100 / max_fuel)
		if $RocketSound.playing == false:
			$RocketSound.play()
		$Flames.emitting = true
			
func shoot():
	if canshoot:
		canshoot = false
		$GunTimer.start()
		var dir = Vector2(0, -1).rotated($Turret.global_rotation)
		emit_signal('spawn_bullet', Bullet, $Turret.global_position, dir)


func land():
	
	if abs(linear_velocity.y) > ground_hit_velocity:
		$Sprite.visible = false
		$Explosion.visible = true
		$FartSound.play()
		$Explosion/AnimationPlayer.play('explode')
	
func _integrate_forces(state): #Screen Wrap

	var xform = state.get_transform()
	
	if xform.origin.x > get_viewport().size.x:
		xform.origin.x = 0		

	if xform.origin.x < 0:
		xform.origin.x = get_viewport().size.x

	if new_position:
		xform.origin = new_position
		new_position = null

	state.set_transform(xform)
	

func _on_Ship_body_entered(body):
	
	var body_name = body.get_name()

	if body_name == "Ground":
		land()	

		
func _on_GunTimer_timeout():
	canshoot = true


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("dead", Vector2(position.x, get_viewport().size.y - 50))
	queue_free()

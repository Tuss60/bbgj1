extends KinematicBody2D

const SPEED = 900

var velocity = Vector2()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce((collision.normal))
		
func set_ball_direction(direction):
	velocity = direction * SPEED

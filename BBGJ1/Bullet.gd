extends KinematicBody2D

const SPEED = 900
const MAX_BOUNCES = 10

var velocity = Vector2()
var currentBounces = 0

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if(currentBounces < MAX_BOUNCES):
			velocity = velocity.bounce((collision.normal))
			currentBounces = currentBounces + 1
			print(currentBounces)
		else:
			call_deferred("free")
		
func set_ball_direction(direction):
	velocity = direction * SPEED


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		get_parent().get_node("Player").touchedBullet()

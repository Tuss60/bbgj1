extends KinematicBody2D

var ghost_id = 0
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var im = get_parent().get_node("InputManager")
	if ghost_id == 0:
		im.manual_update()
	
	var velocity = Vector2()  # The player's movement vector.
	if im.get_right(ghost_id):
		velocity.x += 1
	if im.get_left(ghost_id):
		velocity.x -= 1
	if im.get_down(ghost_id):
		velocity.y += 1
	if im.get_up(ghost_id):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	move_and_collide(velocity * delta)

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x > 0

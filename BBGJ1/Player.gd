extends KinematicBody2D

var ghost_id = 0
var speed = 200
var last_direction_vec = Vector2(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func get_animation_direction(direction_vec: Vector2):
	var norm_direction_vec = direction_vec.normalized()
	if norm_direction_vec.y >= 0.707:
		return "down"
	elif norm_direction_vec.y <= -0.707:
		return "up"
	elif norm_direction_vec.x <= -0.707:
		return "left"
	elif norm_direction_vec.x >= 0.707:
		return "right"
	return "down"
	
func animate_player(direction_vec: Vector2):
	var state = "idle"
	if direction_vec != Vector2.ZERO:
		last_direction_vec = direction_vec
		state = "walk"
	var last_direction = get_animation_direction(last_direction_vec)
	if last_direction == "right":
		$PlayerSprite.flip_h = true
		last_direction = "left"
	else: 
		$PlayerSprite.flip_h = false
	$PlayerSprite.play(state + "_" + last_direction)

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
	velocity = velocity.normalized() * speed
	animate_player(velocity)
		
	move_and_collide(velocity * delta)

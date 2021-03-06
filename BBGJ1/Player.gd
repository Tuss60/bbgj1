extends KinematicBody2D

var ghost_id = -1
var speed = 500
var last_direction_vec = Vector2(0, 1)
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("players")
	if ghost_id != -1:
		# if this is a ghost
		$PlayerSprite.modulate.a = 0.5
	
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
	# temporary hack to test death
	if Input.is_action_just_pressed("shift"):
		die()
	
	if is_dead:
		return
	
	var im = get_parent().get_node("InputManager")
	if ghost_id == -1:
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

	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_collide(velocity * delta)
	
	if im.get_shoot(ghost_id):
		_fire_gun(last_direction_vec.normalized())

func die():
	is_dead = true
	if ghost_id == -1:
		get_parent().on_player_death()
	$PlayerSprite.play("death")


const BALL = preload("res://Bullet.tscn")

func _fire_gun(direction):
	direction = direction.normalized()
	var ball = BALL.instance()
	get_parent().add_child(ball)
	ball.global_position = global_position + (100 * direction)
	ball.set_ball_direction(direction)
	print("playing sound")
	$SoundAttack.play()

func touchedBullet():
	die()

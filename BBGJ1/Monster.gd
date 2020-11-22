extends KinematicBody2D

export var speed = 200
export var health = 3
export var fireball_cooldown = 200
var last_direction_vec : Vector2 = Vector2(0, 1)
var current_direction_vec : Vector2 = Vector2(0, 0)
var special_animation = false
export(NodePath) var ai
var initial_position
var initial_health
var fireball_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ai = get_node(ai)
	$MonsterSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	add_to_group("monsters")
	initial_position = position
	initial_health = health
	
func reset():
	position = initial_position
	health = initial_health
	fireball_time = 0
	animate_monster(Vector2.ZERO)
	if ai:
		ai.reset()
	
func _on_AnimatedSprite_animation_finished():
	var animation_name = $MonsterSprite.animation.split('_')[0]
	if animation_name == "attack":
		print("monster attack animation finished")
	elif animation_name == "hit":
		print("monster hit animation finished")
	elif animation_name == "death":
		print("monster death animation finished")
	special_animation = false
	
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
	
func get_right_corrected_direction(last_direction_vec):
	var last_direction = get_animation_direction(last_direction_vec)
	if last_direction == "right":
		$MonsterSprite.flip_h = true
		last_direction = "left"
	else: 
		$MonsterSprite.flip_h = false
	return last_direction

func animate_monster(direction_vec: Vector2):
	var state = "idle"
	if direction_vec != Vector2.ZERO:
		last_direction_vec = direction_vec
		state = "walk"
	var last_direction = get_right_corrected_direction(last_direction_vec)
	$MonsterSprite.play(state + "_" + last_direction)
	
func monster_attack():
	special_animation = true
	var last_direction = get_right_corrected_direction(last_direction_vec)
	$MonsterSprite.play("attack_" + last_direction)

func monster_hit():
	special_animation = true
	var last_direction = get_right_corrected_direction(last_direction_vec)
	$MonsterSprite.play("hit_" + last_direction)
	
func monster_death():
	special_animation = true
	current_direction_vec = Vector2(0, 0)
	var last_direction = get_right_corrected_direction(last_direction_vec)
	$MonsterSprite.play("death_" + last_direction)

func get_monster_move_vec(delta):
	# Insert logic to determine monster direction
	if ai:
		return ai.get_monster_move_vec(delta)
	return Vector2(0, 0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health == 0:
		return
	var monster_direction = get_monster_move_vec(delta)
	if not special_animation:
		animate_monster(monster_direction)
	
	var collision = move_and_collide(monster_direction * delta)
	
	if collision != null and collision.collider.name != "Player":
		pass # do nothing for now
		
	fireball_time += 1
	if fireball_time == fireball_cooldown:
		fireball_time = 0
		var fireball = preload("res://Fireball.tscn")
		var fb = fireball.instance()
		fb.position = position
		fb.direction = monster_direction.normalized()
		fb.creator = self
		get_parent().add_child(fb)
		
func touchedBullet():
	health = max(health - 1, 0)
	if health == 0:
		monster_death()
	else:
		monster_hit()

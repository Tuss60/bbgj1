extends KinematicBody2D

export var speed = 200
var last_direction_vec : Vector2 = Vector2(0, 1)
var current_direction_vec : Vector2 = Vector2(0, 0)
var special_animation = false

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$MonsterSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	rng.randomize()
	set_new_monster_direction()
	
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

func animate_monster(direction_vec: Vector2):
	var state = "idle"
	if direction_vec != Vector2.ZERO:
		last_direction_vec = direction_vec
		state = "walk"
	var last_direction = get_animation_direction(last_direction_vec)
	if last_direction == "right":
		$MonsterSprite.flip_h = true
		last_direction = "left"
	else: 
		$MonsterSprite.flip_h = false
	$MonsterSprite.play(state + "_" + last_direction)
	
func monster_attack():
	special_animation = true
	var last_direction = get_animation_direction(last_direction_vec)
	$MonsterSprite.play("attack_" + last_direction)

func monster_hit():
	special_animation = true
	var last_direction = get_animation_direction(last_direction_vec)
	$MonsterSprite.play("hit_" + last_direction)
	
func monster_death():
	special_animation = true
	current_direction_vec = Vector2(0, 0)
	var last_direction = get_animation_direction(last_direction_vec)
	$MonsterSprite.play("death_" + last_direction)

func get_monster_move_vec():
	# Insert logic to determine monster direction
	return current_direction_vec
	
func set_new_monster_direction():
	var rand_x = rng.randf_range(-1.0, 1.0)
	var rand_y = rng.randf_range(-1.0, 1.0)
	current_direction_vec = Vector2(rand_x, rand_y) * speed
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var monster_direction = get_monster_move_vec()
	if not special_animation:
		animate_monster(monster_direction)
	
	var collision = move_and_collide(monster_direction * delta)
	
	if collision != null and collision.collider.name != "Player":
		set_new_monster_direction() # bounce around the map for now
		
func touchedBullet():
	monster_hit()


extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ghost_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_player_death():
	# save player's input record
	$InputManager.save_record_and_reset()
	
	# delete all bullets
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.call_deferred("free")
	
	# reset all players (includes ghosts)
	for player in get_tree().get_nodes_in_group("players"):
		player.position = Vector2(0,0)
		player.is_dead = false
		
	# create new ghost
	var player_sc = preload("../Player.tscn")
	var new_ghost = player_sc.instance()
	new_ghost.ghost_id = ghost_counter
	ghost_counter += 1
	add_child(new_ghost)
	
	# give the player the primary camera
	get_node("Player/Camera2D").current = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

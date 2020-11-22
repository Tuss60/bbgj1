extends Node2D

var thisMonster = null
var patrol_points
var patrol_index = 0

export (NodePath) var path

func _ready():
	thisMonster = get_parent()
	if !thisMonster:
		print("ERROR NO PARENT FOR MONSTER AI")
	if path:
		patrol_points = get_node(path).curve.get_baked_points()

func get_monster_move_vec():
	if !path:
		print("ERROR NO PATH SET FOR MONSTER AI")
		return
	var target = patrol_points[patrol_index]
	if thisMonster.position.distance_to(target) < 2:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	return (target - thisMonster.position).normalized() * thisMonster.speed

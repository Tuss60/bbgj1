extends StaticBody2D


export var facing = 0 # 0:up,1:left,2:down,3:right
export(Array, NodePath) var control_nodes # All control nodes must have counter > 1

var is_open = false
var should_be_open = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO add code to choose other textures and reposition plates for other dirctions
	var facing_up = preload("res://Assets/bottomDoor.png")
	$Sprite.texture = facing_up

func open():
	is_open = true
	$Sprite.hide()
	if not $CollisionShape2D.disabled:
		$CollisionShape2D.set_deferred("disabled", true)
	
func close():
	is_open = false
	$Sprite.show()
	if $CollisionShape2D.disabled:
		$CollisionShape2D.set_deferred("disabled", false)

func _physics_process(_delta):
	should_be_open = true
	for nodepath in control_nodes:
		var node = get_node(nodepath)
		if node.counter == 0:
			should_be_open = false
			break
			
func _process(_delta):
	if not is_open and should_be_open:
		call_deferred("open")
	elif is_open and not should_be_open:
		call_deferred("close")

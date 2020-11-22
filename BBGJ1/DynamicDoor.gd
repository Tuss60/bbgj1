extends StaticBody2D


export var facing = 0 # 0:up,1:left,2:down,3:right

var pressurePlate1Counter = 0
var pressurePlate2Counter = 0
var is_open = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO add code to choose other textures and reposition plates for other dirctions
	var facing_up = preload("res://Assets/bottomDoor.png")
	$Sprite.texture = facing_up

func open():
	is_open = true
	$Sprite.hide()
	$CollisionShape2D.disabled = true

func close():
	is_open = false
	$Sprite.show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_open and pressurePlate1Counter > 0 and pressurePlate2Counter > 0:
		open()
	elif is_open and pressurePlate1Counter == 0 or pressurePlate2Counter == 0:
		close()
		
func _on_PressurePlate1_body_entered(body):
	if body.is_in_group("players"):
		pressurePlate1Counter += 1
		if pressurePlate1Counter == 1:
			var active = preload("res://Assets/plateActive.png")
			get_node("PressurePlate1/Sprite").texture = active

func _on_PressurePlate2_body_entered(body):
	if body.is_in_group("players"):
		pressurePlate2Counter += 1
		if pressurePlate2Counter == 1:
			var active = preload("res://Assets/plateActive.png")
			get_node("PressurePlate2/Sprite").texture = active

func _on_PressurePlate1_body_exited(body):
	if body.is_in_group("players"):
		pressurePlate1Counter -= 1
		if pressurePlate1Counter == 0:
			var inactive = preload("res://Assets/plateInactive.png")
			get_node("PressurePlate1/Sprite").texture = inactive

func _on_PressurePlate2_body_exited(body):
	if body.is_in_group("players"):
		pressurePlate2Counter -= 1
		if pressurePlate2Counter == 0:
			var inactive = preload("res://Assets/plateInactive.png")
			get_node("PressurePlate2/Sprite").texture = inactive

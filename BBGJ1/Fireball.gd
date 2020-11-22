extends Area2D

var speed = 15
var direction = Vector2(1, 1).normalized()
var creator


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += speed * direction


func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body.touchedBullet()
		call_deferred("free")
	elif not body == creator:
		call_deferred("free")

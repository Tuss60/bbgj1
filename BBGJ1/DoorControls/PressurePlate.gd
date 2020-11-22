extends Area2D

var counter = 0

func _on_PressurePlate_body_entered(body):
	if body.is_in_group("players"):
		counter += 1
		if counter > 0:
			var active = preload("res://Assets/plateActive.png")
			$Sprite.texture = active

func _on_PressurePlate_body_exited(body):
	if body.is_in_group("players"):
		counter = max(counter - 1, 0)
		if counter == 0:
			var inactive = preload("res://Assets/plateInactive.png")
			$Sprite.texture = inactive

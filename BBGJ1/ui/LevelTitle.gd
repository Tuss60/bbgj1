extends Control

func _ready():
	hide()
	# Not working for some reason
	#warning-ignore:RETURN_VALUE_DISCARDED
	$anim.connect("animation_finished", self, "anim_finished")

func display(lno, title):
	show()
	$VBoxContainer/lno.text = "Level " + str(lno)
	$VBoxContainer/title.text = title
	$anim.play("flicker")
	
func anim_finished(_t):
	hide()

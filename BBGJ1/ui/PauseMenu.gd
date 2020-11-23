extends Control


onready var resume_button = $VBoxContainer/ResumeButton


func _ready():
	visible = false
	_on_VolumeControl_value_changed(0.5)


func close():
	visible = false
	get_tree().paused = false
	$WindowDialog.visible = false


func open():
	visible = true
	get_tree().paused = true
	resume_button.grab_focus()


func _on_ResumeButton_pressed():
	get_node("/root/main").toggle_pause()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Show_Controls_pressed():
	show_help()
	
func show_help():
	$WindowDialog.popup_centered_ratio(0.9)

func _on_VolumeControl_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))

func _input(event):
	if event.is_action_pressed("toggle_pause"):
		get_node("/root/main").toggle_pause()

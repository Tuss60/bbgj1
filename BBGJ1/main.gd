extends Node2D

export(int) var starting_level = 0

var current_lno
var level_scene
var level

signal level_reload

func reset_level():
	change_level(current_lno)

func change_level(lno = current_lno + 1):
	current_lno = lno
	$DisplayWithMinimap.change_level('res://Levels/' + LEVELS.LEVELS[lno])
	$globalControls/LevelIntro.display(lno + 1, LEVELS.LEVEL_TITLES[lno])
	emit_signal("level_reload")

func _ready():
	# Randomize seed
	randomize()
	change_level(starting_level)

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	# The GlobalControls node, in the Stage scene, is set to process even
	# when the game is paused, so this code keeps running.
	# To see that, select GlobalControls, and scroll down to the Pause category
	# in the inspector.

func toggle_pause():
	var tree = get_tree()
	tree.paused = not tree.paused
	if tree.paused:
		$globalControls/PauseMenu.open()
	else:
		$globalControls/PauseMenu.close()
	get_tree().set_input_as_handled()

func show_help():
	toggle_pause()
	$globalControls/PauseMenu.show_help()

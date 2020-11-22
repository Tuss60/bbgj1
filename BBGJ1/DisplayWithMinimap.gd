extends Node2D

onready var viewport = $ViewportContainer/Viewport
onready var camera = $ViewportContainer/Viewport/Camera2D

onready var minimap = $MinimapContainer/Minimap
onready var minimap_camera = $MinimapContainer/Minimap/Camera2D

var level_scene
var level

func change_level(level_path):
	if level:
		viewport.remove_child(level)
	level_scene = load(level_path)
	level = level_scene.instance()
	viewport.add_child(level)
	minimap.world_2d = viewport.world_2d
	camera.current = true
	camera.target = level.get_node("Player")
	minimap_camera.target = camera.target

func _ready():
#	change_level('res://Levels/TemplateLevel.tscn')
	pass

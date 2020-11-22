extends Node2D

onready var viewport = $ViewportContainer/Viewport
onready var camera = $ViewportContainer/Viewport/Camera2D
onready var world = $ViewportContainer/Viewport/world

onready var minimap = $MinimapContainer/Minimap
onready var minimap_camera = $MinimapContainer/Minimap/Camera2D

func _ready():
	minimap.world_2d = viewport.world_2d
	camera.target = world.get_node("Player")
	minimap_camera.target = camera.target

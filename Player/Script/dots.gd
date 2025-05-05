extends MeshInstance3D

@export var player_root: CharacterBody3D 
@export var label_position: Label
@export var upnode: RayCast3D
@export var head: Marker3D 

@onready var x_axis_debugger = $XAxis
@onready var y_axis_debugger = $YAxis
@onready var z_axis_debugger = $ZAxis
var axis_of_priority: Vector3 = Vector3(0,0,0)

func _process(_delta: float) -> void:
	var relative_position = get_static_position()
	label_position.text = "Posisi: " + str(relative_position)
	if relative_position.y < 1 or upnode.is_colliding() == true:
		
		if player_root.global_rotation.y < 1.0 and player_root.global_rotation.y > -1.0:
			z_axis_visible()
		elif player_root.global_rotation.y > 2.0 or player_root.global_rotation.y < -2.0:
			z_axis_visible()
		else:
			x_axis_visible()
	else:
		y_axis_visible()

func get_static_position()->Vector3:
	return position -player_root.position

func x_axis_visible():
	x_axis_debugger.visible = true
	y_axis_debugger.visible = false
	z_axis_debugger.visible = false
	axis_of_priority = Vector3(1,0,0)

func y_axis_visible():
	x_axis_debugger.visible = false
	y_axis_debugger.visible = true
	z_axis_debugger.visible = false
	axis_of_priority = Vector3(0,1,0)
func z_axis_visible():
	x_axis_debugger.visible = false
	y_axis_debugger.visible = false
	z_axis_debugger.visible = true
	axis_of_priority = Vector3(0,0,1)

extends Camera3D


@export var player: Marker3D
var offset: Vector3
var offset_rotation: Vector3
func _ready() -> void:
	offset = global_position
	offset_rotation = rotation
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = player.global_position + offset
	rotation = player.rotation + offset_rotation



#@export var player: CharacterBody3D
#@export var offset: Vector3
#func _ready() -> void:
	#offset = global_position
#
#func _process(delta: float) -> void:
	#global_position = player.global_position + offset

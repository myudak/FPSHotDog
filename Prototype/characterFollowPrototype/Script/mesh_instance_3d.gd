extends MeshInstance3D

@export var player: CharacterBody3D
@export var offset: Vector3
func _ready() -> void:
	offset = global_position

func _process(delta: float) -> void:
	global_position = player.global_position + offset

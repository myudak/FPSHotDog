extends Marker3D

@onready var raycast :RayCast3D = $Camera3D/RayCast3D
@onready var dots: MeshInstance3D = $Dots
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		#var collision_normal = raycast.get_collision_normal()
		dots.position = collision_point
		#dots.rotation = collision_normal

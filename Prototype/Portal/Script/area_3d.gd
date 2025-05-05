extends Area3D
@export var marker: Marker3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("entity"):
		if body is RigidBody3D:
			print("Teleporting...")

			var from_basis = global_transform.basis
			var to_basis = marker.global_transform.basis
			var old_velocity = body.linear_velocity

			# Transform velocity agar sesuai arah portal tujuan
			var new_velocity = to_basis * from_basis.inverse() * old_velocity

			# Teleport posisi
			body.global_position = marker.global_position

			# Update velocity
			body.linear_velocity = new_velocity

			# Transform rotasi badan (sesuai portal tujuan)
			var new_rotation = to_basis.get_rotation_quaternion()
			body.rotation = new_rotation.get_euler()

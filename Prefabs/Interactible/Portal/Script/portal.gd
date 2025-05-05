extends Area3D

@export var portal_connection: Area3D
var connector_spawn_position: Vector3
var connector_spawn_rotation: Vector3

func _ready() -> void:
	$Position_Spawn/Dummy.visible = false
	connector_spawn_position = $Position_Spawn.global_position
	connector_spawn_rotation = $Position_Spawn.global_rotation
	print(connector_spawn_position)
	print(Vector3(connector_spawn_rotation.x,connector_spawn_rotation.y + 180,connector_spawn_rotation.z))

func _on_body_entered(body: Node3D) -> void:
	#teleportation(body)
	if body.is_in_group("entity"):
		if body is CharacterBody3D:
			var from_basis = global_transform.basis
			var to_basis = portal_connection.global_transform.basis
			print("basis: " + str(to_basis))
			body.global_position = connector_spawn_position

func teleportation(body)-> void:
	if not body.is_in_group("entity"):
		return

	var destination_portal = portal_connection
	var dest_position = destination_portal.connector_spawn_position
	var from_basis = global_transform.basis
	var to_basis = destination_portal.global_transform.basis

	# === Untuk RigidBody3D
	if body is RigidBody3D:
		var original_velocity = body.linear_velocity
		var rotated_velocity = to_basis * from_basis.inverse() * original_velocity

		body.global_position = dest_position
		body.linear_velocity = rotated_velocity

	# === Untuk CharacterBody3D
	elif body is CharacterBody3D:
		var original_velocity = body.velocity
		var rotated_velocity = to_basis  * original_velocity

		body.global_position = dest_position
		body.velocity = rotated_velocity

		# Rotasi badan (yaw)
		var from_yaw = global_rotation.y
		var to_yaw = destination_portal.global_rotation.y
		var delta_yaw = to_yaw - from_yaw
		body.rotation.y += delta_yaw

		# Rotasi kamera (pitch)
		#if body.has_node("Head/Camera3D"):
			#var camera = body.get_node("Head/Camera3D")
			#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
			## Kamu juga bisa reset pitch jika ingin (misalnya ke 0):
			#camera.rotation.x = 0.0

	else:
		# Fallback untuk node lainnya
		body.global_position = dest_position

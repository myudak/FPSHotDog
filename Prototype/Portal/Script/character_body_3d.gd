extends CharacterBody3D

const SPEED_NORMAL = 5.0
const SPEED_SPRINT = 8.0
const JUMP_VELOCITY= 4.5

var speed
var sensitivity:float = 0.001


func _ready() -> void:
	speed = SPEED_NORMAL
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("ui_sprint"):
		speed = SPEED_SPRINT
	else:
		speed = SPEED_NORMAL
func _physics_process(delta: float) -> void:

	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input
	var input_dir := Input.get_vector("ui_up", "ui_down", "ui_right", "ui_left")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Target movement
	var target_velocity = direction * speed

	# Akselerasi dan Friksi
	var acceleration = 10.0
	var friction = 8.0
	var air_control = 3.0

	if is_on_floor():
		if direction:
			# Gerakan dengan akselerasi saat ada input
			velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
			velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)
		else:
			# Perlambatan karena friksi saat idle
			velocity.x = lerp(velocity.x, 0.0, friction * delta)
			velocity.z = lerp(velocity.z, 0.0, friction * delta)
	else:
		# Di udara, kontrol arah lebih kecil
		velocity.x = lerp(velocity.x, target_velocity.x, air_control * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, air_control * delta)

	move_and_slide()

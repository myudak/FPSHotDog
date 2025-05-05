extends CharacterBody3D

const SPEED_NORMAL = 5.0
const SPEED_SPRINT = 8.0
const JUMP_VELOCITY= 4.5

var speed
var sensitivity:float = 0.001

var negative_encounter: Vector3 = Vector3(0,0,0)
var max_move_vector: Vector3
@export var level_can_be_scratch: Node3D
@export var size_strach: int 
@export var max_move: int
@onready var head:Marker3D = $Head
@onready var camera:Camera3D = $Head/Camera3D
@onready var label_akselrasi: Label = $CanvasLayer/Panel/VBoxContainer/Akselrasi
@onready var label_rotasi: Label = $CanvasLayer/Panel/VBoxContainer/Rotasi
@onready var label_position: Label = $CanvasLayer/Panel/VBoxContainer/Position
@onready var label_max_move: Label = $CanvasLayer/Panel2/Max_move
@onready var dots: MeshInstance3D = $Head/Dots
@onready var map_label_status: Label = $CanvasLayer/MapScaleStatus/MapScaleStatusLabel

# --- Tambahan untuk smoothing ---
var target_scale: Vector3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Head/Camera3D/AnimationPlayer.play("attach")
	speed = SPEED_NORMAL
	target_scale = level_can_be_scratch.scale # inisialisasi
	
	max_move_vector.x = max_move+1
	max_move_vector.y = max_move+1
	max_move_vector.z = max_move+1
	print(max_move_vector)
func _unhandled_input(event: InputEvent) -> void:
	## --- movement --- ##
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90),deg_to_rad(90))
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("ui_sprint"):
		speed = SPEED_SPRINT
	else:
		speed = SPEED_NORMAL
		
	level_strach(size_strach)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Target movement
	var target_velocity = direction * speed

	# Akselerasi dan Friksi
	var acceleration = 10.0
	var friction = 8.0
	var air_control = 3.0

	if is_on_floor():
		if direction:
			$Head/Camera3D/AnimationPlayer.play("walk")
			velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
			velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction * delta)
			velocity.z = lerp(velocity.z, 0.0, friction * delta)
	else:
		velocity.x = lerp(velocity.x, target_velocity.x, air_control * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, air_control * delta)

	move_and_slide()

	# --- Smooth scaling transition ---
	var smoothing_speed = 1 # semakin besar, semakin cepat smooth-nya
	level_can_be_scratch.scale = level_can_be_scratch.scale.lerp(target_scale, smoothing_speed * delta)

	# --- Debugging --- #
	var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
	label_akselrasi.text = "Speed:  " + str(horizontal_velocity.length())
	label_rotasi.text = "Rotasi: " + str(head.global_rotation)
	label_max_move.text = "Maks Step: "+ str(max_move_vector)
	map_label_status.text = "map size: "+ str(level_can_be_scratch.scale)
	
func level_strach(size_scratch: int):
	if Input.is_action_just_pressed("ui_subtract_stratch"):
		if dots.axis_of_priority == Vector3(1,0,0) and max_move_vector.x <= max_move+1 :
			target_scale.x -= size_scratch
			negative_encounter.x -= 1
			max_move_vector.x += 1
		elif dots.axis_of_priority == Vector3(0,1,0)and max_move_vector.y <= max_move +1:
			target_scale.y -= size_scratch
			negative_encounter.y -= 1
			max_move_vector.y += 1
		elif dots.axis_of_priority == Vector3(0,0,1)and max_move_vector.z <= max_move+1 :
			target_scale.z -= size_scratch
			negative_encounter.z -= 1
			max_move_vector.z += 1
	elif Input.is_action_just_pressed("ui_add_scratch"):
		if dots.axis_of_priority == Vector3(1,0,0) and max_move_vector.x > 0:
			target_scale.x += size_scratch
			negative_encounter.x += 1
			max_move_vector.x -= 1
		elif dots.axis_of_priority == Vector3(0,1,0) and max_move_vector.y > 0:
			target_scale.y += size_scratch
			negative_encounter.y += 1
			max_move_vector.y -= 1
		elif dots.axis_of_priority == Vector3(0,0,1) and max_move_vector.z > 0:
			target_scale.z += size_scratch
			negative_encounter.z += 1
			max_move_vector.z -= 1

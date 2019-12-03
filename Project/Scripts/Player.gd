extends KinematicBody

# Raycasting vars for determining mouse position in 3d
var ray_length = 1000
onready var camera = $Camera
var space_state = null
var mouse_pos = null
var from = null
var to = null
var result = null

var gravity = Vector3.DOWN * 12
var speed = 4
var jump_speed = 6
var spin = .1
var jump = false

var velocity = Vector3()

onready var raycast = $Camera/RayCast

func _physics_process(delta):
	space_state = get_world().get_direct_space_state()
	mouse_pos = get_viewport().get_mouse_position()
	from = camera.project_ray_origin(mouse_pos)
	to = from + camera.project_ray_normal(mouse_pos) * ray_length
	result = space_state.intersect_ray(from, to, [self])
	velocity += gravity * delta
	get_input()
	move_and_slide(velocity, Vector3.UP)
	if jump and is_on_floor():
		velocity.y = jump_speed
	
func get_input():
	var vy = velocity.y
	velocity = Vector3()
	if Input.is_action_pressed("move_up"):
		velocity -= transform.basis.z*speed
	if Input.is_action_pressed("move_down"):
		velocity += transform.basis.z*speed
	if Input.is_action_pressed("move_left"):
		velocity -= transform.basis.x*speed
	if Input.is_action_pressed("move_right"):
		velocity += transform.basis.x*speed
	velocity.y = vy
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
		
func _unhandled_input(event):
	if event is InputEventMouseMotion and space_state:	
		if result:
			var dir = translation.angle_to(result['position'])
			$MeshHolder.rotation.y = dir
			print(dir)
extends KinematicBody

# Raycasting vars for determining mouse position in 3d
var ray_length = 1000
onready var camera = $Camera
var space_state = null
var mouse_pos = null
var from = null
var to = null
var result = {}

# Movement vars
var gravity = Vector3.DOWN * 12
var speed = 4
var jump_speed = 6
var spin = .1
var jump = false
var velocity = Vector3()

# In Game Statistics
var hp = float(100) # Health. If this reaches 0 the player dies
var hunger = float(100) # Hunger. Higher hunger values means more health regen. Lower values means less health regen and other effects
var thirst = float(100) # Thirst. Similar to hunger. Decreases faster, easier to replenish
var money = 0 # Money the player has. Used for bartering if we add that.
var materials = 0 # Materials for crafting, repair, etc
# Note about base rates: MUST be decimals. Fractions do not work for some reason
var base_hp_regen = .25 # Per timer iteration
var base_hunger_rate = -.25 # Per timer iteration
var base_thirst_rate = -.5 # Per timer iteration
var hp_mod = 1 # Modifications from things like hunger, thirst, bleed etc.
var hunger_mod = 1
var thirst_mod = 1

# Dynamic Containers. Player attributes that can change durring gameplay
var effects = {} # Effects the player may be expereincing. Stuctured as string name:[(attribute1,value1),(attribute2,value2)...]
var inventory = [] # Player's Inventory. List of nodes
var goals = [] #Each goal has the following attributes

# Static Containers. Player attributes that will not change during gameplay


# HUD elements
onready var hp_label = $Hud/ColorRect4/Health
onready var hunger_label = $Hud/ColorRect3/Hunger
onready var thirst_label = $Hud/ColorRect2/Thirst

# Nodes
onready var attribute_timer = $AttributeTimer

class effect:
	enum {ADD,MULTIPLY,SET}
#	var attributes = []
#	var length = -1
#	var title = ''
	func _init(n:String,l:=-1,a := []):
		var attributes = a
		var length = l
		var title = n
	
	func apply_effect():
		for attribute in self.attributes:
			attribute[0] += attribute[1]
		self.length -= 1
			
	func end_effect():
		pass

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
		
	# Updating values
	if attribute_timer.is_stopped():
		hp += base_hp_regen*hp_mod
		hunger += base_hunger_rate*hunger_mod
		thirst += base_thirst_rate*thirst_mod
		attribute_timer.start()
		
	if hp > 100:
		hp = 100
		
	if hunger > 100:
		hunger = 100
	elif hunger < 0:
		hunger = 0
		
	if thirst > 100:
		thirst = 100
	elif thirst < 0:
		thirst = 0
	
	# Updating HUD
	hp_label.text = 'Health: '+str(int(hp))
	hunger_label.text = 'Hunger: '+str(int(hunger))
	thirst_label.text = 'Thirst: '+str(int(thirst))
		
func _process(delta):
	pass
	
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
	if Input.is_action_just_pressed("left_click"):
		print(hp,hunger,thirst)
		
func _unhandled_input(event):
#	if event is InputEventMouseMotion and space_state:	
#		if result:
#			print(result['position'],translation)
#			var dir = translation.angle_to(result['position'])
#			$MeshHolder.rotation.y = diar
	pass
extends StaticBody

export var accepts = ''
export var affects = ''
var fulfilled = false
var item = null

signal effect

func _ready():
	var display = get_parent().find_node(accepts).sprite
	item = get_parent().get_node(accepts)
	$Sprite3D.texture = display
	connect("effect",get_node(affects),"activation_effect")
	
func _physics_process(delta):
	$Sprite3D.visible = false
	$Pointer.visible = false
	if translation.distance_to(get_parent().get_node('Player').translation) < 4 and not fulfilled:
		display_input()
		
	if get_parent().get_node(accepts) in $Area.get_overlapping_bodies() and not fulfilled:
		accept_input()

func apply_effects():
	emit_signal("effect")

func accept_input():
	print('accepted')
	fulfilled = true
	item = get_parent().get_node(accepts)
	item.remove_from_group('takeable')
	item.translation = translation + Vector3(0,2,0)
	apply_effects()
	
func display_input():
	$Sprite3D.visible = true
	$Pointer.visible = true
	

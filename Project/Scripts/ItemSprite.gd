extends RigidBody

var inventory_item = null
var copy = null
export var sprite = preload("res://Assets/Colored/genericItem_color_153.png")
var in_player_range = false

func _ready():
	$Sprite3D.texture = sprite
	copy = load("res://Scenes/ItemSprite.tscn")
	inventory_item = load("res://Scenes/InventoryItem.tscn").instance()
	
func _physics_process(delta):
	set_in_player_range()
	
func set_in_player_range():
#	in_player_range = value
	if get_parent().get_node('Player').translation.distance_to(translation)<4:
		$Pointer.visible = true
	else:
		$Pointer.visible = false

func transfer_to_hotbar():
	var inv_item = inventory_item
	inv_item.name = name
	inv_item.world_item = clone()
	inv_item.sprite = sprite
	get_parent().get_node('Player/Hud/Hotbar').add_child(inv_item)
	queue_free()
	
func clone():
	var new_instance = copy.instance()
	var properties = get_property_list()
	var new_instance_children = new_instance.get_children()
	for property in properties:
		new_instance.set(property['name'],self.get(property['name']))
	for child in new_instance_children:
		var child_properties = child.get_property_list()
		var original_child = get_node(child.name)
		for child_property in child_properties:
			child.set(child_property['name'],original_child.get(child_property['name']))
	return new_instance
extends RigidBody

var inventory_item = null
var copy = null

func _ready():
	copy = load("res://Scenes/Item.tscn")
	inventory_item = load("res://Scenes/InventoryItem.tscn")

func transfer_to_hotbar():
	var inv_item = inventory_item.instance()
	inv_item.world_item = clone()
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
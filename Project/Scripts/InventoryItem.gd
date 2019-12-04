extends Area2D

var dragged = false
var moused_over = false
var last_holder = null
export var sprite = preload("res://icon.png")
var in_transfer = false
var player = null

var world_item = null
var copy = null

func _ready():
	$Sprite.texture = sprite
	world_item = load("res://Scenes/ItemSprite.tscn").instance()
	copy = load("res://Scenes/InventoryItem.tscn")
	player = get_tree().get_nodes_in_group('Player')[0]
	
func _physics_process(delta):
	if in_transfer and Input.is_action_just_released("left_click"):
		last_holder.set_occupied(false)
		transfer_to_world(player.result['position']+Vector3(0,1,0))
	elif moused_over and Input.is_action_pressed("left_click"):
		last_holder.set_occupied(false)
		position = get_viewport().get_mouse_position()
		dragged = true
	elif dragged or not last_holder:
		last_holder = get_closest_item_holder()
		last_holder.set_occupied(true)
		last_holder.set_last_held(self)
		position = last_holder.position
		dragged = false
		moused_over = false

func _on_InventoryItem_mouse_entered():
	if not Input.is_action_pressed("left_click"):
		moused_over = true

func _on_InventoryItem_mouse_exited():
	if not Input.is_action_pressed("left_click"):
		moused_over = false
		
func get_closest_item_holder():
	var holders = get_tree().get_nodes_in_group("Inventory Item Holder")
	var min_distance = position.distance_squared_to(holders[0].position)
	var closest_holder = holders[0]
	for holder in holders:
		var distance = position.distance_squared_to(holder.position)
		if distance < min_distance and not holder.occupied:
			closest_holder = holder
			min_distance = distance
	return closest_holder
	
func transfer_to_world(pos):
	var item = world_item
	item.translation = pos
	item.inventory_item = clone()
	item.get_node('Sprite3D').texture = $Sprite.texture
	get_tree().current_scene.add_child(item)
	queue_free()

func _on_InventoryItem_area_entered(area):
	if area.is_in_group('Transfer'):
		in_transfer = true


func _on_InventoryItem_area_exited(area):
	if area.is_in_group('Transfer'):
		in_transfer = false

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
	
	
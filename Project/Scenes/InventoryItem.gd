extends Area2D

var dragged = false
var moused_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if moused_over and Input.is_action_pressed("left_click"):
		position = get_viewport().get_mouse_position()
		dragged = true
	else:
		position = get_closest_item_holder().position

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
		if distance < min_distance:
			closest_holder = holder
			min_distance = distance
	return closest_holder
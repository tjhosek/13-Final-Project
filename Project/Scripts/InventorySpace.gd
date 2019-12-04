extends Node2D

var occupied = false
var last_held = null
var hover = false

func _ready():
	pass # Replace with function body.


func set_occupied(value,text=''):
	occupied = value
	$Label.text = text
		
	
func set_last_held(value):
	last_held = value
	
#func _unhandled_input(event):
#	if event is InputEventMouseButton:
#		print(name,occupied)

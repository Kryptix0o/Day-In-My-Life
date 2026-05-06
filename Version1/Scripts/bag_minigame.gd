extends Control

var items_in_bag = 0
var total_items = 4
var dragging = null
var drag_offset = Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			for item in [$Laptop, $Bottle, $Book, $Charger]:
				if item.get_node("TextureRect").get_global_rect().has_point(event.position):
					dragging = item
					drag_offset = item.position - event.position
		else: 
			if dragging:
				if $Bag.get_global_rect().has_point(event.position):
					dragging.visible = false
					items_in_bag += 1
					if items_in_bag >= total_items:
						complete()
			dragging = null

func _process(_delta):
	if dragging:
		dragging.position = get_viewport().get_mouse_position() + drag_offset
		
func complete():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().root.find_child("Label", true, false).add_theme_color_override("font_color", Color.GREEN)
	get_tree().root.find_child("BagZone", true, false).get_parent().monitoring = false
	get_tree().root.find_child("BagPrompt", true, false).visible = false
	get_tree().root.find_child("BagSprite", true, false).visible = false

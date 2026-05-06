extends Area3D

var player_inside = false
@onready var door = get_parent()

func _ready():
	$"../../CanvasLayer/DoorPrompt".visible = false
	door.visible = false

func _on_body_entered(body):
	if body.name == "CharacterBody3D":
		player_inside = true
		update_state()
		
func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_inside = false
		update_state()
		
func _process(_delta):
	update_state()
	
	if player_inside and all_labels_green() and Input.is_action_just_pressed("exit_door"):
		get_tree().change_scene_to_file("res://Version2/Scenes/outside.tscn")
		
func update_state():
	var unlocked = all_labels_green()
	
	door.visible = unlocked 
	$"../../CanvasLayer/DoorPrompt".visible = player_inside and unlocked
		
func all_labels_green() -> bool:
	var label1 = get_tree().root.find_child("Label", true, false)
	var label2 = get_tree().root.find_child("Label2", true, false)
	var label3 = get_tree().root.find_child("Label3", true, false)
	
	if label1 == null or label2 == null or label3 == null:
		return false
	
	return (
		label1.get_theme_color("font_color") == Color.GREEN and
		label2.get_theme_color("font_color") == Color.GREEN and
		label3.get_theme_color("font_color") == Color.GREEN
	)

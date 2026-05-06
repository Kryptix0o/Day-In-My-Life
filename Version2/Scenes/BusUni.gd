extends Area3D

var player_inside = false 

func _ready():
	$"../../CanvasLayer/BusPrompt".visible = false
	get_tree().root.find_child("Label3D", true, false).visible = true
	
func _on_body_entered(body):
	if body.name == "CharacterBody3D":
		player_inside = true
		$"../../CanvasLayer/BusPrompt".visible = true
		
func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_inside = false
		$"../../CanvasLayer/BusPrompt".visible = false
		
func _process(_delta):
	if player_inside and Input.is_action_just_pressed("busuni"):
		get_tree().change_scene_to_file("res://Version2/Scenes/endscreen.tscn")

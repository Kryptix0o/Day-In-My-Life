extends Area3D

var player_inside = false 

func _ready():
	$"../../CanvasLayer/InteractPrompt".visible = false
	get_tree().root.find_child("Label3D", true, false).visible = true
	
func _on_body_entered(body):
	if body.name == "CharacterBody3D":
		player_inside = true
		$"../../CanvasLayer/InteractPrompt".visible = true
		
func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_inside = false
		$"../../CanvasLayer/InteractPrompt".visible = false
		
func _process(_delta):
	if player_inside and Input.is_action_just_pressed("busnpc"):
		$"../BusSounds".play()
		$"../../CanvasLayer/InteractPrompt".visible = false
		player_inside = false
		monitoring = false
		var label3d = get_tree().root.find_child("Label3D", true, false)
		label3d.text = "Catch me!"
		label3d.visible = true
		await get_tree().create_timer(3.0).timeout
		label3d.visible = false
		get_parent().visible = false
	

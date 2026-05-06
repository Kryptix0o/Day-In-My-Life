extends Area3D
var player_inside = false
var keys_grabbed = false 

func _ready():
	$"../../CanvasLayer/KeyPrompt".visible = false

func _on_body_entered(body):
	if body.name == "CharacterBody3D" and not keys_grabbed:
		player_inside = true
		$"../../CanvasLayer/KeyPrompt".visible = true
		
func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_inside = false
		$"../../CanvasLayer/KeyPrompt".visible = false
		
func _process(_delta):
	if player_inside and Input.is_action_just_pressed("grab_keys"):
		keys_grabbed = true 
		$"../KeySound".play()
		get_tree().root.find_child("Keys", true, false).visible = false
		get_tree().root.find_child("Label2", true, false).add_theme_color_override("font_color", Color.GREEN)
		$"../../CanvasLayer/KeyPrompt".visible = false
		player_inside = false
		monitoring = false

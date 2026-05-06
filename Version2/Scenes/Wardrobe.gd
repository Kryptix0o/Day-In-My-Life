extends Area3D
var player_inside = false
var keys_grabbed = false 

func _ready():
	$"../../CanvasLayer/WardrobePrompt".visible = false

func _on_body_entered(body):
	if body.name == "CharacterBody3D" and not keys_grabbed:
		player_inside = true
		$"../../CanvasLayer/WardrobePrompt".visible = true
		
func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_inside = false
		$"../../CanvasLayer/WardrobePrompt".visible = false
		
func _process(_delta):
	if player_inside and Input.is_action_just_pressed("get_dressed"):
		get_tree().root.find_child("Label3", true, false).add_theme_color_override("font_color", Color.GREEN)
		$"../../CanvasLayer/WardrobePrompt".visible = false
		player_inside = false	
		monitoring = false

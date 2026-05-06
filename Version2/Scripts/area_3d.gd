extends Area3D

var player_inside = false

func _ready():
	$"../../CanvasLayer/BagPrompt".visible = false
	$"../../CanvasLayer/BagMinigame".visible = false

func _on_body_entered(body):
	if body.name == "CharacterBody3D":
		player_inside = true
		$"../../CanvasLayer/BagPrompt".visible = true
		
func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_inside = false
		$"../../CanvasLayer/BagPrompt".visible = false

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("open_bag"):
		$"../BagOpenSound".play()
		$"../../CanvasLayer/BagMinigame".visible = true
		$"../../CanvasLayer/BagPrompt".visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

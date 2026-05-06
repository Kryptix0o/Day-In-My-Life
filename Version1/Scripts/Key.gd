extends Node3D

var player_inside = false

func _ready():
	$"../../CanvasLayer/KeyPrompt".visible = false

func _on_body_entered(body):
	if body.name == "CharacterBody3D":
		player_inside = true
		$"../../CanvasLayer/KeyPrompt".visible = true
		
func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_inside = false
		$"../../CanvasLayer/KeyPrompt".visible = false

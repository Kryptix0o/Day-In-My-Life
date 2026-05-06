extends Area3D

var player_inside = false

func _ready():
	$"../CanvasLayer/WindowPrompt".visible = false

func _on_body_entered(body):
	if body.name == "CharacterBody3D":
		player_inside = true
		$"../CanvasLayer/WindowPrompt".visible = true
		
func _on_body_exited(body):
	if body.name == "CharacterBody3D":
		player_inside = false
		$"../CanvasLayer/WindowPrompt".visible = false
		
func _process(_delta):
	if player_inside and Input.is_action_just_pressed("change_sky"):
		var env = $"../WorldEnvironment".environment
		(env.sky.sky_material as ProceduralSkyMaterial).sky_top_color = Color(randf(), randf(), randf())

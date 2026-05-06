# A Day in my Life

Name: Dziugas

Student Number: A00037886

Class Group: TU984

# Gameplay Demo Video
[![YouTube](Images/thumb.png)](https://www.youtube.com/watch?v=6IOZ8FoUsBg)

# Screenshots

Titlescreen Image
![Title](Images/title.png)
2D Gameplay
![Title](Images/2dimg.png)
3D Gameplay
![Title](Images/3dimg.png)

# Description of Project
A game dedicated to the 2026 final assessment for Creative Coding.
Spend the morning gathering your belongings and rushing for the bus.
With a task list, you cannot leave until you have remembered to complete your daily tasks.

# Instructions for use
Run the game through the web on [Itch](https://kryptix0.itch.io/my-daily-life).
Interact with the window to change the sky with V next to the window.
Interact with the NPC, as well as complete tasks by going near their collision and pressing E when given the prompt.
WASD to move, Space to jump, M1 during minigame to drag objects into bag.

# How it works
A Day in my Life uses a lot of checks for true and false, whether this is to check on collisions between the player and collisions between task items, as well as the window, up to NPC interaction. 
Tasks specifically check for the colour GREEN in the script to ensure all tasks are GREEN before allowing a prompt to exit the room.
Built as an exploration game to do with daily life, it is a linear game with a set goal.

Checks
- True/False on colours to allow collision on door
- All items gathered
- Input on keys to toggle sky colours
- Input on keys to toggle interaction within range

Change of Scenes
- Menu
- Main Scene
- Credits
- Outside
- End Screen

Minigame
- Tasks:
- Packing bag
- Collecting key
- Putting clothes on

# List of classes/assets in the project

| Class/asset | Source | Use |
|-----------|-----------|-----------|
| BusNPC.gd | Self written | Interaction of First Bus NPC |
| BusUni.gd | Self written | Gateway to End Screen |
| character_body_3d.gd | Self written | Movement/Head Bobbing |
| credits_probably.gd | Self written | Credits with Back Arrow |
| Door.gd | Self written | Checks for green labels |
| endscreen.gd | Self written | Animate between 2 images |
| Key.gd | Self written | Handles Key interaction |
| main_menu.gd | Self written | Gateway to Start/Credits/Quit |
| panel.gd | Self written | If tasks are complete, makes task green |
| wardrobe.gd | Self written | Handles Wardrobe interaction |
| window_zone.gd | Self written | Handles Colour Switching Through RGB |
| area3d.gd | Self written | Interaction With Bag / Gateway to Minigame |
| bag_minigame.gd | Self written | Minigame which counts items in collision of bag |

# What I'm most proud of this assignment
- Dziugas Januska
Learning code through youtube videos and being able to mash it all together to create something, as well as adapt on my blender knowledge. 
Slightly more comfortable with using github through pushing godot aspects.

# What I learned
Minigames which use dragging positions, true/false checks, coloured text checks, NPCs

# Code Examples

## BusNPC

```GDScript
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
	
```

## BusUni

```GDScript
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
```

## character_body_3d

```GDScript
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera_pivot: Node3D = $CameraPivot
var mouse_sensitivity := 0.002
var pitch := 0.0

var bob_time := 0.0
var camera_base_pos: Vector3
var walk_bob_intensity := 0.08
var idle_bob_intensity := 0.02
var bob_speed := 8.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	camera_base_pos = camera_pivot.position
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad (-15), deg_to_rad(40))
		camera_pivot.rotation.x = pitch

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		var is_moving := Vector2(velocity.x, velocity.z).length() > 0.1
		bob_time += delta * bob_speed
		var bob_amount := 0.0
		
		if is_moving:
			bob_amount = sin(bob_time) * walk_bob_intensity
		else:
			bob_amount = sin(bob_time) * idle_bob_intensity
			
			camera_pivot.position.y = camera_base_pos.y + bob_amount

	move_and_slide()

```

## character_body_3d

```GDScript
extends Node2D


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Version2/Scenes/main_menu.tscn")

```

## Door

```GDScript
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
		$"../DoorSound".play()
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

```

## endscreen

```GDScript
extends Node2D

@onready var image1 = $TextureRect
@onready var image2 = $TextureRect2

func _ready():
	image1.visible = true
	image2.visible = false
	
	while true:
		await get_tree().create_timer(1.0).timeout
		image1.visible = false
		image2.visible = true
		
		await get_tree().create_timer(1.0).timeout
		image1.visible = true
		image2.visible = false

```

## Key

```GDScript
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

```

## main_menu

```GDScript
extends Node2D


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Version2/Scenes/game_scene.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Version2/Scenes/credits_probably.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

```

## panel

```GDScript
extends Panel

func cross_off(task_number):
	if task_number == 1:
		$VBoxContainer/Label.add_theme_color_override("font_color", Color.GREEN)
	elif task_number == 2:
		$VBoxContainer/Label2.add_theme_color_override("font_color", Color.GREEN)
	elif task_number == 3:
		$VBoxContainer/Label3.add_theme_color_override("font_color", Color.GREEN)

```

## Wardrobe

```GDScript
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
		$WardrobeZone/WardrobeSound.play()
		get_tree().root.find_child("Label3", true, false).add_theme_color_override("font_color", Color.GREEN)
		$"../../CanvasLayer/WardrobePrompt".visible = false
		player_inside = false	
		monitoring = false

```

## character_body_3d

```GDScript

```

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

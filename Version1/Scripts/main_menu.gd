extends Node2D


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Version1/Scenes/game_scene.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Version1/Scenes/credits_probably.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

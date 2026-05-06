extends Panel

func cross_off(task_number):
	if task_number == 1:
		$VBoxContainer/Label.add_theme_color_override("font_color", Color.GREEN)
	elif task_number == 2:
		$VBoxContainer/Label2.add_theme_color_override("font_color", Color.GREEN)
	elif task_number == 3:
		$VBoxContainer/Label3.add_theme_color_override("font_color", Color.GREEN)

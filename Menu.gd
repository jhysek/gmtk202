extends Node2D

func _ready():
	
	$Title.get_font("font").font_data.antialiased = false
	$Title.get_font("font").use_filter = true
	$Title.get_font("font").use_filter = false
	
	$Button.get_font("font").font_data.antialiased = false
	$Button.get_font("font").use_filter = true
	$Button.get_font("font").use_filter = false

func _on_Button_pressed():
	LevelSwitcher.start_level()


func _on_Button_mouse_entered():
	$Hover.play()

func _on_Button_mouse_exited():
	$Hover.play()

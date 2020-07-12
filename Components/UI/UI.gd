extends Control

func fix_font(elem):
	elem.get_font("font").font_data.antialiased = false
	elem.get_font("font").use_filter = true
	elem.get_font("font").use_filter = false


# Called when the node enters the scene tree for the first time.
func _ready():
	fix_font($GameOver/Label)
	fix_font($GameOver/RestartBtn)
	fix_font($GameOver/RestartBtn2)
	

func _on_RestartBtn_pressed():
	LevelSwitcher.restart_level()


func _on_RestartBtn2_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_NextBtn_pressed():
	LevelSwitcher.next_level()


func _on_Timer_timeout():
	_on_NextBtn_pressed()

func start_timer():
	$WellDone/Timer.start()

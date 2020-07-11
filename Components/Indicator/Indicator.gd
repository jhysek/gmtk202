extends Area2D

onready var game = get_node("/root/Game")
onready var progress = $ProgressBar

export var NORMAL_OFF = Color(1,1,1,0.4)
export var NORMAL_ON  = Color(1,1,1,1)
export var SELECTED_OFF = Color("FFD300")
export var SELECTED_ON  = Color("FFD300")

var map_position = Vector2(0, 0)

var selected = false

func _ready():
	$Sprite.modulate = NORMAL_OFF

func set_progress(value):
	progress.value = value
		
func _on_Indicator1_mouse_entered():
	if (selected):
		$Sprite.modulate = SELECTED_ON
	else:
		$Sprite.modulate = NORMAL_ON
		
func _on_Indicator1_mouse_exited():
	if (selected):
		$Sprite.modulate = SELECTED_OFF
	else:
		$Sprite.modulate = NORMAL_OFF
		

func select():
	$Sprite.modulate = SELECTED_OFF
	selected = true
	progress.show()
	
func unselect():
	$Sprite.modulate = NORMAL_OFF
	selected = false
	progress.hide()

func _on_Indicator1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		map_position = game.world_to_map(position)
		game.indicator_clicked(self)


func _on_AnimationPlayer_animation_finished(anim_name):
	if false and anim_name == "Appear":
		$AnimationPlayer.play("Pulse")

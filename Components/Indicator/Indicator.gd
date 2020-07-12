extends Area2D

onready var game = get_node("/root/Game")
onready var progress = $ProgressBar

export var NORMAL_OFF = Color(1,1,1,0.4)
export var NORMAL_ON  = Color(1,1,1,1)
export var SELECTED_OFF = Color("FFD300")
export var SELECTED_ON  = Color("FFD300")
export var DISABLED     = Color(0,0,0,0)

var map_position = Vector2(0, 0)

var selected = false
var disabled = false

func _ready():
	$Sprite.modulate = NORMAL_OFF

func set_progress(value):
	progress.value = value
		
func disable():
	$Sprite.modulate = DISABLED
	disabled = true
		
func enable():
	$Sprite.modulate = NORMAL_OFF
	disabled = false
	
func _on_Indicator1_mouse_entered():
	if disabled:
		return
		
	if (selected):
		$Sprite.modulate = SELECTED_ON
	else:
		$Sprite.modulate = NORMAL_ON
		
func _on_Indicator1_mouse_exited():
	if disabled:
		return
		
	if (selected):
		$Sprite.modulate = SELECTED_OFF
	else:
		$Sprite.modulate = NORMAL_OFF
		
func set_map_pos(m_pos):
	map_position = m_pos

func select():
	if disabled: 
		return
		
	$Node/Select.play()
	$Sprite.modulate = SELECTED_OFF
	selected = true
	progress.show()
	
func unselect():
	if disabled: 
		return
	$Sprite.modulate = NORMAL_OFF
	selected = false
	progress.hide()

func _on_Indicator1_input_event(viewport, event, shape_idx):
	if !disabled and event is InputEventMouseButton and event.pressed:
		map_position = game.world_to_map(position)
		game.indicator_clicked(self)


func _on_AnimationPlayer_animation_finished(anim_name):
	if false and anim_name == "Appear":
		$AnimationPlayer.play("Pulse")

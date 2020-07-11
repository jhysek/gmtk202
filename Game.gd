extends Node2D

export var CELL_SIZE = 32
export var STEP_TIME = 3

var indicators = 0
var started = false
var exit_map_pos = Vector2(0,0)
var step_time = 0
var selected_indicator 

onready var player = $Player

func _ready():
	exit_map_pos = world_to_map($Exit.position)
	$Exit.position = map_to_world(exit_map_pos)
	$Player.jump_to(Vector2(10,10))
	draw_indicators()
	
func start():
	started = true
	set_process(true)
	
func _process(delta):
	if started:
		step_time += delta
		if selected_indicator:
			print(step_time)
			selected_indicator.set_progress(step_time / STEP_TIME * 100)
			
		if step_time >= STEP_TIME:
			step_time = 0
			player.jump_to(world_to_map(selected_indicator.position))
	
	
func indicator_clicked(indicator):
	if not started:
		start()
		
	for ind in $Indicators.get_children():
		ind.unselect()
		
	indicator.select()
	selected_indicator = indicator
	
	var line = $Player/SelectedLine
	line.get_node("AnimationPlayer").play("FadeIn")
	line.set_point_position(1, Vector2(0, indicator.position.y - player.position.y))
	line.set_point_position(2, indicator.position - player.position)
	

func jumped_at(map_pos: Vector2):
	print("=> " + str(map_pos))
	print("? " + str(exit_map_pos))
	
	$Player/SelectedLine.hide()

	
	if (map_pos == exit_map_pos):
		print("FINUSHED")
		started = false
		hide_indicators()
	else:
		draw_indicators()
			
func map_to_world(map_pos: Vector2):
	return map_pos * CELL_SIZE - Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
	
func world_to_map(world_pos: Vector2):
	var wp = world_pos / CELL_SIZE
	return Vector2(round(wp.x), round(wp.y))

func hide_indicators():
	for indicator in $Indicators.get_children():
		indicator.get_node("AnimationPlayer").play_backwards("Appear")
		
func draw_indicators():
	for indicator in $Indicators.get_children():
		indicator.hide()
		indicator.get_node("AnimationPlayer").stop()
	indicators = 0
	$Timer.start()
	$Player/SelectedLine/AnimationPlayer.play("FadeIn")
	
func _on_Timer_timeout():
	if indicators < 8:
		indicators += 1
		$Indicators.get_node("Indicator" + str(indicators) + "/AnimationPlayer").play("Appear")
	else:
		$Timer.stop()

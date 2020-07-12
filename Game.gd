extends Node2D

export var CELL_SIZE = 32
export var STEP_TIME = 3
export var map_size = Vector2(10, 10)

var indicators = 0
var moves = -1
var started = false
var exit_map_pos = Vector2(0,0)
var step_time = 0
var selected_indicator 

var map = []

onready var player = $Player

func _ready():
	$CanvasLayer/UI/Label.get_font("font").font_data.antialiased = false
	$CanvasLayer/UI/Label.get_font("font").use_filter = true
	$CanvasLayer/UI/Label.get_font("font").use_filter = false
	
	$CanvasLayer/UI/LevelNumber.text = "LEVEL " + str(LevelSwitcher.current_level + 1)
	$CanvasLayer/AnimationPlayer.play("LevelStart")
	
	exit_map_pos = world_to_map($Exit.position)
	$Exit.position = map_to_world(exit_map_pos)
	$Player.jump_to(world_to_map($Start.position) + Vector2(1,0))
	draw_indicators()
	
	for enemy in $Enemies.get_children():
		enemy.generate_navigation()
	

func start():
	started = true
	$Music.play()
	$Player/SelectedLine.show()
	set_process(true)
	
func _process(delta):
	if started:
		step_time += delta
		if selected_indicator:
			selected_indicator.set_progress(step_time / STEP_TIME * 100)
			
		if step_time >= STEP_TIME:
			step_time = 0
			player.jump_to(world_to_map(selected_indicator.position))
			for enemy in $Enemies.get_children():
				enemy.jump_to_next_pos()
	
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
	
func redraw_moves():
	$CanvasLayer/UI/Label.text = "MOVES: " + str(moves)

func jumped_at(map_pos: Vector2):
	moves += 1
	redraw_moves()
	
	print("JUMPED TO: " + str($Map.get_cellv(map_pos - Vector2(1,1))))
	if $Map.get_cellv(map_pos - Vector2(1,1)) < 2:
		$Player.die()
			
	if (map_pos == exit_map_pos):
		started = false
		$CanvasLayer/AnimationPlayer.play("WellDone")
		$Player/SelectedLine.hide()
		hide_indicators()
	
	if started:
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
		indicator.enable()
		indicator.get_node("AnimationPlayer").stop()
		
		indicator.set_map_pos(world_to_map(indicator.position))
		var cell = $Map.get_cellv(indicator.map_position - Vector2(1,1))
		if cell == 1 || cell == 0:
			indicator.disable()
	indicators = 0
	$Timer.start()
	$Player/SelectedLine/AnimationPlayer.play("FadeIn")
	
func _on_Timer_timeout():
	if indicators < 8:
		indicators += 1
		$Indicators.get_node("Indicator" + str(indicators) + "/AnimationPlayer").play("Appear")
	else:
		$Timer.stop()

func over():
	started = false
	hide_indicators()
	$Music.stop()
	$CanvasLayer/AnimationPlayer.play("LevelFailed")


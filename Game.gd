extends Node2D

export var CELL_SIZE = 32

var started = false
var exit_map_pos = Vector2(0,0)

onready var player = $Player

func _ready():
	exit_map_pos = world_to_map($Exit.position)
	$Exit.position = map_to_world(exit_map_pos)
	
	$Player.position = map_to_world(Vector2(10,10))	
	
func start():
	$Timer.start()
	
func _on_Timer_timeout():
	player.jump()

func jumped_at(world_pos: Vector2):
	var map_pos = world_to_map(world_pos)
	print("=> " + str(map_pos))
	print("? " + str(exit_map_pos))
	
	if (map_pos == exit_map_pos):
		print("FINUSHED")
		started = false

func map_to_world(map_pos: Vector2):
	return map_pos * CELL_SIZE - Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
	
func world_to_map(world_pos: Vector2):
	var wp = world_pos / CELL_SIZE
	return Vector2(round(wp.x), round(wp.y))

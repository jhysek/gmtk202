extends Node2D

var map_pos

onready var game = get_node("/root/Game")

var map_position
var next_move
										
func jump_to(m_pos):
	if map_position: 
		next_move = m_pos - map_position
	map_position = m_pos
	position = game.map_to_world(map_position)
	game.jumped_at(map_position)
	
func die():
	queue_free()

extends Sprite

const MOVES = [
	[KEY_Q, Vector2(-2, -1)],
	[KEY_W, Vector2(-1, -2)],
	[KEY_E, Vector2(1, -2)],
	[KEY_R, Vector2(2, -1)],
	[KEY_F, Vector2(2, 1)],
	[KEY_D, Vector2(1, 2)],
	[KEY_S, Vector2(-1, 2)],
	[KEY_A, Vector2(-2, 1)],	
]

onready var indicators = get_node("/root/Game/Indicators")
onready var game = get_node("/root/Game")

var map_position
var jump_position
var next_move
					
					
func jump_to(m_pos):
	if map_position: 
		next_move = m_pos - map_position
	map_position = m_pos
	position = game.map_to_world(map_position)
	set_indicatpr_positions()
	game.jumped_at(map_position)
	
func jump():
	next_move = jump_position - map_position
	map_position = jump_position
	position = game.map_to_world(map_position)
	game.jumped_at(map_position)
	jump_position = jump_position + next_move
	
func set_indicatpr_positions():
	var idx = 1
	for move in MOVES:
		indicators.get_node("Indicator" + str(idx)).position = game.map_to_world(map_position + move[1])
		idx += 1		
	
func draw_possible_move(move):
	pass

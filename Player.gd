extends Sprite

var CELL_SIZE = 32
const MOVES = [
	[KEY_Q, Vector2(-2, -1)],
	[KEY_W, Vector2(-1, -2)],
	[KEY_E, Vector2(1, -2)],
	[KEY_R, Vector2(2, -1)],
	[KEY_A, Vector2(-2, 1)],
	[KEY_S, Vector2(-1, 2)],
	[KEY_D, Vector2(1, 2)],
	[KEY_F, Vector2(2, 1)],
]

onready var indicator1 = get_node("/root/Game/Indicator1")
onready var indicator2 = get_node("/root/Game/Indicator2")
onready var indicator3 = get_node("/root/Game/Indicator3")
onready var indicator4 = get_node("/root/Game/Indicator4")
onready var game = get_node("/root/Game")

var jump_position
var next_move

func _ready():
	CELL_SIZE = game.CELL_SIZE
	jump_position = position 
	set_process_input(true)

func _input(event):
	if event is InputEventKey:
		#if !game.started:
	#		game.start()
			
		for move in MOVES:
			if Input.is_key_pressed(move[0]):
				if event.pressed:
					next_move = move[1]
					jump_position = position + next_move * CELL_SIZE
					draw_indicators()
					
		if Input.is_action_just_pressed("ui_accept") and next_move:
			jump()
			
func jump():
	position = jump_position
	jump_position = position + next_move * CELL_SIZE
	game.jumped_at(position)
	draw_indicators()
	
func draw_indicators():
	var path = get_path()
	indicator1.position = position
	indicator2.position = position + path[1] * CELL_SIZE
	indicator3.position = position + path[2] * CELL_SIZE
	indicator4.position = jump_position
	

func get_path():
	var path = []
	var diff_x = -1 if next_move.x < 0 else 1
	var diff_y = -1 if next_move.y < 0 else 1
	
	for x in range(0, next_move.x + diff_x, diff_x):
		for y in range(0, next_move.y + diff_y, diff_y):
			path.append(Vector2(x, y))
			
	print(path)
	return path

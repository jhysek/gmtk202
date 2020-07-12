extends Node2D

var map_pos

const MOVES = {
	"knight": [
		Vector2(-2, -1),
		Vector2(-1, -2),
		Vector2(1, -2),
		Vector2(2, -1),
		Vector2(2, 1),
		Vector2(1, 2),
		Vector2(-1, 2),
		Vector2(-2, 1),	
	],
	"king": [
		Vector2(-1, 0),
		Vector2(1, 0),
		Vector2(0, -1),
		Vector2(1, 0)
	]
}

onready var game = get_node("/root/Game")

export var enemy_type = "king";

var map_position
var next_move
var points = 0
var added_locations = {}
var tilemap: TileMap
var path = []


var nav = AStar2D.new()

func _ready():
	jump_to(Vector2(8, 8))
	print("ENEMY's position: " + str(map_position) + " (" + str(position) + ")")
					
func generate_navigation():
	generate_nav_map(game.get_node("Map"))
	path = get_shortest_path(map_position, game.exit_map_pos)
	
func jump_to_next_pos():
	if !path.empty():
		var next_pos = path[0]
		path.remove(0)
		jump_to(next_pos)
	
func get_shortest_path(from_pos: Vector2, to_pos: Vector2):
	if added_locations.has(from_pos) and added_locations.has(to_pos):
		var path = nav.get_point_path(added_locations[from_pos], added_locations[to_pos])
		print("connection between: " + str(from_pos) + " to " + str(to_pos))
		print(nav.are_points_connected(added_locations[from_pos], added_locations[to_pos]))
		return path	
	else:
		print("NO PATH :(")
		return []
		

func jump_to(m_pos):
	if map_position: 
		next_move = m_pos - map_position
	map_position = m_pos
	position = game.map_to_world(map_position)
	
func die():
	queue_free()
	
func generate_nav_map(tmap: TileMap):
	tilemap = tmap
	points += 1
	print("ADDING " + str(map_position) + " ID: " + str(points))
	nav.add_point(points, map_position)
	added_locations[map_position] = points
	generate_moves_from(points, map_position)
	
				
func generate_moves_from(from_id: int, map_pos: Vector2):
	print("GEnerating moves from " + str(map_pos) + " ID: " + str(from_id) + " (" + str(added_locations[map_pos]) +")")
	var next_level = []
	
	for move in MOVES[enemy_type]:
		var move_pos = map_pos + move
		#print("TILE AT " + str(move_pos) + " = " + str(tilemap.get_cellv(move_pos - Vector2(1,1))))
		if tilemap.get_cellv(move_pos - Vector2(1,1)) >= 0:
			#print(" tile OK, adding")
			var point_id = add_point_from(from_id, move_pos)
			if point_id:
				next_level.append([point_id, move_pos])
	
	for location in next_level:
		generate_moves_from(location[0], location[1])	


func add_point_from(from_id, new_point_pos):
	if !added_locations.has(new_point_pos):
		points += 1
		
		#print("ADDING " + str(new_point_pos) + " ID: " + str(points))
		added_locations[new_point_pos] = points
		nav.add_point(points, new_point_pos)
		#print(str(from_id)+ " => " + str(new_point_pos))
		nav.connect_points(from_id, points)
		return points
	else:
		nav.connect_points(from_id, added_locations[new_point_pos])
		return false

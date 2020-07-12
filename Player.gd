extends Node2D

var Bullet = preload("res://Components/Bullet/Bullet.tscn")

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
var tween_path = []
var dead = false
										
func jump_to(m_pos):
	var move = Vector2(0,0)	
	
	if map_position:
		next_move = m_pos - map_position
		move = m_pos - map_position
		$Sprite.flip_h = move.x < 0

	map_position = m_pos
	
	$SelectedLine/AnimationPlayer.play_backwards("FadeIn")
	$Tween.interpolate_property(self, 'position', position, game.map_to_world(map_position), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	$Sfx/Move.play()
	set_indicator_positions()
	
	game.jumped_at(map_position)
	#if move != Vector2(0,0):
	#	shot(move.x)	
	
	
func set_indicator_positions():
	var idx = 1
	for move in MOVES:
		indicators.get_node("Indicator" + str(idx)).position = game.map_to_world(map_position + move[1])
		idx += 1		
	
func shot(direction):
	var bullet = Bullet.instance()
	bullet.position = position 
	bullet.fire(direction)
	bullet.shooter = self
	get_node("/root/Game").add_child(bullet)
	
func die():
	$Sfx/Death.play()
	dead = true
	$Camera2D.shake(0.5, 50, 20)
	game.over()
	hide()

func _on_Tween_tween_completed(object, key):
	$SelectedLine/AnimationPlayer.play("FadeIn")

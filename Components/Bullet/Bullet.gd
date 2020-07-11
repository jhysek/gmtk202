extends Area2D

const SPEED = 200
var direction
var lifetime = 5
var shooter

func fire(dir):
	if dir < 0:
		direction = -1
	else:
		direction = 1
	set_physics_process(true)
	
	
func _physics_process(delta):
	if direction:
		position.x = position.x + direction * (delta * SPEED)
		lifetime -= delta
		
		if lifetime <= 0:
			queue_free()


func _on_Bullet_area_entered(area):
	var area_parent = area.get_parent()
	if area_parent.is_in_group("Killable") and area_parent != shooter:
		queue_free()
		area_parent.die()

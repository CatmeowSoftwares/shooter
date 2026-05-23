class_name Enemy extends Character
var target: Character
var target_pos: Vector3
var boss: bool
func set_target_pos(pos: Vector3):
	target_pos = pos
	
func set_target(p_target: Character):
	target = p_target
	
func attack():
	pass

@abstract
class_name Character extends CharacterBody3D
signal death
@export var health: int
@export var speed = 2.5
@export var defense: float #should be between 0.0 and 1.0

var jump_velocity = 4.5



func get_horizontal_speed() -> float:
	return get_horizontal_velocity().length()
	
func get_horizontal_velocity() -> Vector2:
	return Vector2(velocity.x, velocity.z)
func jump():
	velocity.y = jump_velocity
func slow_down_air(delta:float):
	var vel : Vector3 = velocity
	vel = vel.move_toward(Vector3.ZERO, (max(velocity.length(), speed)*5) * delta)
	velocity = vel
func slow_down(delta: float):
	if not is_on_floor():
		return 
	if get_horizontal_speed() < 0.01:
		return
	var vel = get_horizontal_velocity()
	vel = vel.move_toward(Vector2.ZERO, (max(get_horizontal_speed(), speed)*2) * delta)
	velocity.x = vel.x
	velocity.z = vel.y
func _on_difficulty_change(difficulty: Global.Difficulty):
	match difficulty:
		Global.Difficulty.EASY:
			pass
		Global.Difficulty.MEDIUM:
			pass
		Global.Difficulty.HARD:
			pass
func _ready() -> void:
	Global.difficulty_changed.connect(_on_difficulty_change)
	death.connect(_on_death)
func push_rigid_bodies():
	for i in get_slide_collision_count():
		var body = get_slide_collision(i)
		var collider = body.get_collider()
		if collider is RigidBody3D:
			collider.apply_central_impulse(-body.get_normal() * 2)

func knockback(dir: Vector3):
	velocity += dir
func damage(val: int):
	health -= val * (1.0 - defense)
	if health <= 0:
		death.emit()

func kill():
	death.emit()
func _on_death():
	queue_free()

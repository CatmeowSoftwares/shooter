extends Enemy
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var attack_interval: Timer = $AttackInterval
const MAX_SPEED = 10.0
func _ready() -> void:
	super()
	match Global.difficulty:
		Global.Difficulty.EASY:
			speed = 2.5
		Global.Difficulty.MEDIUM:
			speed = PI
		Global.Difficulty.HARD:
			speed = 5.0
	
func _physics_process(delta: float) -> void:
	push_rigid_bodies()
	navigation_agent.target_position = target.position
	var v = navigation_agent.get_next_path_position()
	var vel = (v - global_position).normalized();
	slow_down(delta)
	
	if target.position.distance_to(global_position) > 1.0:
		var h_speed = get_horizontal_speed()
		if is_on_floor():
			velocity.x += vel.x * speed
			velocity.z += vel.z * speed
		var new_h_speed = get_horizontal_speed()
		var norm = get_horizontal_velocity().normalized()
		if new_h_speed > speed:
			velocity.x = norm.x * h_speed
			velocity.z = norm.y * h_speed
	else:
		attack()
	if not is_on_floor():
		velocity += get_gravity() * delta
	rotation.y = atan2(-velocity.x, -velocity.z)
	move_and_slide()
	
	
func attack():
	if !attack_interval.is_stopped():
		return
	target.damage(1)
	attack_interval.start()

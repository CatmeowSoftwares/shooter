extends Enemy
@onready var cooldown: Timer = $Cooldown
@onready var rocket_launcher: Node3D = $RocketLauncher

func _ready() -> void:
	match Global.difficulty:
		Global.Difficulty.EASY:
			cooldown.wait_time = 2.0
		Global.Difficulty.MEDIUM:
			cooldown.wait_time = 1.0
		Global.Difficulty.HARD:
			cooldown.wait_time = 0.5
	cooldown.start()
func _physics_process(delta: float) -> void:
	rocket_launcher.look_at(target.global_position)
	if not is_on_floor():
		velocity += get_gravity() * delta
	rotation.y = atan2(-target.position.x, -target.position.z)
	move_and_slide()

func attack():
	rocket_launcher.use(self)


func _on_cooldown_timeout() -> void:
	attack()

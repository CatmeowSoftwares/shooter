extends Enemy

@onready var dash_timer: Timer = $DashTimer

func _physics_process(delta: float) -> void:
	look_at(target.position)
	slow_down_air(delta)
	move_and_slide()

func dash_toward_target():
	velocity = transform.basis.z * -25

func dash():
	velocity = transform.basis.x * (10 * random_neg())
func random_neg() -> int:
	if (randi() % 2) < 1:
		return -1
	else:
		return 1
func _on_dash_timer_timeout() -> void:
	match randi() % 2:
		0:
			dash_toward_target()
		1:
			dash()

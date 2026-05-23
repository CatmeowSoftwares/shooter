extends Enemy
var follower: Enemy
var head: Enemy

func _ready() -> void:
	speed = 20

func _physics_process(delta: float) -> void:
	if is_instance_valid(follower):
		velocity = ((follower.transform * Vector3.BACK) - position)  * speed# * follower.position.distance_to(position)
		look_at(follower.position)
	else:
		velocity = Vector3.ZERO
	move_and_slide()

func damage(val: int):
	if head:
		head.damage(val)

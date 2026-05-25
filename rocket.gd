extends CharacterBody3D
@onready var projectile: Projectile = $Projectile

func _ready() -> void:
	projectile.hit.connect(_on_hit)
	velocity = -transform.basis.z
	
func _physics_process(delta: float) -> void:
	move_and_slide()
func _on_area_3d_body_entered(body: Node3D) -> void:
	projectile.hit.emit()
	if body is Character:
		body.damage(10)

		

func explode():
	if is_queued_for_deletion():
		return
	var explosion: Explosion = preload("uid://dvywl4dxqer1p").instantiate()
	explosion.position = global_position
	explosion.radius = 2.0
	get_tree().root.add_child(explosion)
	queue_free()

func _on_hit():
	explode()
	queue_free()
	
	

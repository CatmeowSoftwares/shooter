class_name Projectile extends WeaponFire
signal hit
@onready var lifetime: Timer = $Lifetime




func _on_lifetime_timeout() -> void:
	queue_free()

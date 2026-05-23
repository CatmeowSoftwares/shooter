@abstract 
class_name Weapon extends Node3D
@onready var cooldown: Timer = $Cooldown
@onready var alt_cooldown: Timer = $AltCooldown
enum FireType {
	CLICK,
	HOLD,
}
enum AltFireType {
	CLICK,
	HOLD,
}
var fire_type: FireType = FireType.CLICK
var alt_fire_type: FireType = FireType.HOLD
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@abstract
func use(user: Character)
func alt_use(user: Character):
	pass

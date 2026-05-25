extends Weapon
@onready var marker: Marker3D = $Marker3D

func use(user: Character):
	var rocket = preload("uid://bespfoi5r0n4d").instantiate()
	
	#preload("uid://i2vgut0m1lyo").instantiate()
	rocket.transform = marker.global_transform
	rocket.owner = rocket.get_parent()
	get_tree().root.add_child(rocket)

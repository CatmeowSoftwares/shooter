extends Game

@onready var label_3d: Label3D = $Label3D

var wave: int
var points: int
var enemy_count: int
@onready var enemy_1: CharacterBody3D = $Enemy1

func _ready():
	Engine.time_scale = 0.5
	var pistol = preload("uid://beon7rk2hh6u5").instantiate()
	var rocket_launcher = preload("uid://d4kjhq0idgagt").instantiate()
	var piercer = preload("uid://cpg77rwivgpgh").instantiate()
	var railgun = preload("uid://bnipj5kwcdi2j").instantiate()
	spawn_weapon(pistol)
	#spawn_weapon(rocket_launcher)
	#spawn_weapon(railgun)
	#spawn_weapon(piercer)
	start_next_wave()
	#var a= preload("uid://crkpkv63jxoy2").instantiate()
	#a.position = Vector3(2, 0, 2)
	#a.rotation_degrees.x = -30
	#add_child(a)
func spawn_weapon(weapon: Weapon):
	var dropped_weapon = preload("uid://bliw0nb4auxri").instantiate()
	dropped_weapon.weapon = weapon
	dropped_weapon.add_child(weapon)
	dropped_weapon.position = Vector3(0, 2, 1)
	add_child(dropped_weapon)
	




func start_next_wave():
	await get_tree().create_timer(1.0).timeout
	wave += 1
	label_3d.text = "Wave %d" % wave
	spawn_enemies()

func spawn_enemies():
	var enemies := [
		preload("uid://dx142vanqasmg"),
		preload("uid://iyblt7u7uoca"),
		preload("uid://ci3ikftome340"),
		#preload("uid://crkpkv63jxoy2"),
		
	]
	for i in range(20):
		enemy_count += 1
		var enemy: Enemy = enemies.pick_random().instantiate()
		enemy.death.connect(_on_enemy_death)
		enemy.position.x = randf_range(-50, 50)
		enemy.position.z = randf_range(-50, 50)
		add_child(enemy)


func _on_enemy_death():
	enemy_count -= 1
	if enemy_count <= 0:
		start_next_wave()


func _on_void_body_entered(body: Node3D) -> void:
	if body is Character:
		body.kill()

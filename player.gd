class_name Player extends Character

const MAX_SPEED = 10.0
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var slide_timer: Timer = $SlideTimer
@onready var head: Node3D = $Head
@onready var hand: Node3D = $Head/Hand
@onready var progress_bar: ProgressBar = $ProgressBar

const SENSITIVITY = 0.01;
const PLAYER_HEIGHT = 1.8
var is_crouching: bool
var is_sliding: bool
var current_weapon: Weapon


@onready var label: Label = $Label
func _ready() -> void:
	super()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	progress_bar.max_value = health
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_x(-event.relative.y * SENSITIVITY);
		head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90, 90)
		rotate_y(-event.relative.x * SENSITIVITY)
func _process(_delta: float) -> void:
	progress_bar.value = health
func _physics_process(delta: float) -> void:
	push_rigid_bodies()
	get_tree().call_group("Enemy", "set_target", self)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not is_sliding:
		slow_down(delta)
	if Input.is_action_just_pressed("crouch"):
		if is_on_floor() && get_horizontal_speed() >= 1.0:
			slide()
		else:
			crouch()
	elif Input.is_action_just_released("crouch"):
		uncrouch()
	if current_weapon != null:
		match current_weapon.fire_type:
			Weapon.FireType.CLICK:
				if Input.is_action_just_pressed("left_click"):
					if current_weapon.cooldown.is_stopped():
						current_weapon.use(self)
						current_weapon.cooldown.start()
			Weapon.FireType.HOLD:
				if Input.is_action_just_pressed("left_click"):
					current_weapon.cooldown.start()
				elif Input.is_action_just_released("left_click"):
					if current_weapon.cooldown.is_stopped(): 
						current_weapon.use(self)
					current_weapon.cooldown.stop()
						

		match current_weapon.alt_fire_type:
			Weapon.AltFireType.CLICK:
				if Input.is_action_just_pressed("right_click"):
					if current_weapon.alt_cooldown.is_stopped(): 
						current_weapon.alt_use(self)
						current_weapon.alt_cooldown.start()
			Weapon.AltFireType.HOLD:
				if Input.is_action_just_pressed("right_click"):
					current_weapon.alt_cooldown.start()
				elif Input.is_action_just_released("right_click"):
					if current_weapon.alt_cooldown.is_stopped(): 
						current_weapon.alt_use(self)
					current_weapon.alt_cooldown.stop()
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()
		if is_sliding:
			uncrouch()
			velocity.x *= 1.2
			velocity.z *= 1.2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var power = 1.0
		var h_speed = get_horizontal_speed()
		if is_sliding or not is_on_floor():
			power = 0.1
		
		velocity.x += direction.x * power
		velocity.z += direction.z * power
		var new_h_speed = get_horizontal_speed()
		var norm = get_horizontal_velocity().normalized()
		if new_h_speed > MAX_SPEED:
			velocity.x = norm.x * MAX_SPEED
			velocity.z = norm.y * MAX_SPEED
		var norm2 = get_horizontal_velocity().normalized()
		if not is_on_floor() or is_sliding:
			velocity.x = norm2.x * h_speed
			velocity.z = norm2.y * h_speed
			# max movement velocity -> 5.0

	move_and_slide()
	label.text = str(get_horizontal_speed())


func crouch():
	if  is_crouching:
		return
	is_crouching = true
	speed = MAX_SPEED/2.0
	var shape = collision_shape.shape
	if shape is CapsuleShape3D:
		shape.height = PLAYER_HEIGHT/2.0
		if is_on_floor():
			position.y -= PLAYER_HEIGHT/4.0
	var mesh = mesh_instance.mesh
	if mesh is CapsuleMesh:
		mesh.height = PLAYER_HEIGHT/2.0
	
func slide():
	slide_timer.start()
	is_sliding = true
	if get_horizontal_speed() < speed:
		velocity *= 1.5
	crouch()

func uncrouch():
	if !is_crouching:
		return
	is_sliding = false
	is_crouching = false
	speed = MAX_SPEED
	var shape = collision_shape.shape
	if shape is CapsuleShape3D:
		shape.height = PLAYER_HEIGHT
		if is_on_floor():
			position.y += PLAYER_HEIGHT/4.0
		
	var mesh = mesh_instance.mesh
	if mesh is CapsuleMesh:
		mesh.height = PLAYER_HEIGHT


func pick_up(weapon: Weapon):
	current_weapon = weapon


func _on_death():
	position = Vector3.ZERO


func _on_slide_timer_timeout() -> void:
	uncrouch()

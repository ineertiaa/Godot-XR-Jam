extends CharacterBody3D

@export var spawn_point: Node3D

@onready var btn = $"../Scene/Button/Thing"

const speed = 0.5
const jump_vel = 0

const max_health = 100
var current_health = max_health

var vignette_amount = 0

func _ready() -> void:
	motion_mode = CharacterBody3D.MOTION_MODE_FLOATING 

func _physics_process(delta: float) -> void:	
	# Add the gravity.
	#if not is_on_floor():
		# velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_vel

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


	move_and_slide()

func player_take_damage(damage):
	current_health -= damage
	vignette_amount += current_health / 125.0
	$XROrigin3D/XRCamera3D/CanvasLayer/ColorRect.get_material().set_shader_parameter("alpha", vignette_amount)
	if (current_health <= 0):
		die()
		
	print(current_health)
	
func die():
	current_health = max_health
	
	cleanup()
	
func cleanup():
	var waves = get_node("../WaveManager")
	for enemy in waves.current_enemies:
		enemy.queue_free()
		
	waves.enemies_to_spawn = waves.original_enemies_to_spawn
	waves.enemies_to_add = waves.original_enemies_to_add
	
	vignette_amount = 0
	$XROrigin3D/XRCamera3D/CanvasLayer/ColorRect.get_material().set_shader_parameter("alpha", vignette_amount)
		
	$"../Scene/Button/Thing".reset()
		
	global_position = spawn_point.position

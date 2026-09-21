extends CharacterBody3D

@onready var navmesh = $NavigationAgent3D

const speed = 5.0
const jump_vel = 4.5

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	set_target($"../XROrigin3D")

	var goto = navmesh.get_next_path_position()
	var current_location = global_transform.origin
	var new_vel = (goto - current_location).normalized() * speed
	
	velocity = velocity.move_toward(new_vel, 0.25)

	move_and_slide()
	
func set_target(target):
	navmesh.target_position = target

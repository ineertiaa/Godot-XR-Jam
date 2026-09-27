extends Node3D

@onready var tip = $Tip
@export var bullet: PackedScene

@onready var timer = $GunCooldown
@onready var player = $"../../.." 

var canShoot = true

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_select") and canShoot):
		shoot()

func shoot() -> void:
	var new_bullet = bullet.instantiate() as RigidBody3D
	get_tree().current_scene.add_child(new_bullet)
	new_bullet.global_transform = tip.global_transform
	
	new_bullet.apply_impulse(-tip.get_global_transform().basis.z * 10)
	
	player.velocity += global_transform.basis.z.normalized()  * 50.0
	
	cooldown()

func cooldown() -> void:
	canShoot = false
	timer.start()

func _on_gun_cooldown_timeout() -> void:
	canShoot = true

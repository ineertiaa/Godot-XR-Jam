extends RigidBody3D

@onready var player = $"../../PlayerBody"

var bounce_tween: Tween

var squish_divide = 2

@onready var normal_scale = global_transform.basis.get_scale()

signal on_enemy_died(enemy: Node3D)

const maxHealth = 100
var currentHealth = maxHealth

var speed = 5.0
var sight_range = 50.0

var can_attack = true

func _physics_process(delta: float) -> void:
	var dist_to_player = global_position.distance_to(player.position)
	
	if (can_attack and dist_to_player < sight_range):
		attack()
		
	

func attack() -> void:
	can_attack = false
	$AttackCooldown.start()
	
	var player_dir = (player.global_position - global_position).normalized()
	
	if (bounce_tween):
		bounce_tween.kill()
		
	bounce_tween = create_tween()
	bounce_tween.tween_property($MeshInstance3D, "scale", Vector3(normal_scale.x, normal_scale.y / squish_divide, normal_scale.z), 0.1)
	bounce_tween.tween_property($MeshInstance3D, "scale", normal_scale, 0.1)
	
	apply_impulse(player_dir * 10.0)

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
	
func enemy_take_damage(damage) -> void:
	currentHealth -= damage
	
	if (currentHealth <= 0):
		on_enemy_died.emit(self)
		queue_free()
		
	apply_impulse(-get_global_transform().basis.z * 10.0)
		
	print(currentHealth)

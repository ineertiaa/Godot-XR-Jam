extends RigidBody3D

var damage = 60

func _ready() -> void:
	$TimeUntilDestroy.start()

func _on_body_entered(body: Node):           
	if (body.has_method("enemy_take_damage")):
		body.enemy_take_damage(damage)
		
	if (body.has_method("activate")):
		body.activate()
		
func _on_time_until_destroy_timeout() -> void:
	queue_free()

extends Area3D

var damage = 30

func _on_body_entered(body: Node3D) -> void:
	if (body is CharacterBody3D and body.has_method("player_take_damage")):
		body.player_take_damage(damage)

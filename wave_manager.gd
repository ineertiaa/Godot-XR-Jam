extends Node3D

@export var enemy_prefabs: Array[PackedScene] = []
@export var spawn_points: Array[Node3D] = []

var current_enemies = []

var enemies_to_spawn = 3
@onready var original_enemies_to_spawn = enemies_to_spawn

var enemies_to_add = 2
@onready var original_enemies_to_add = enemies_to_add

func spawn_wave():
	for i in range(enemies_to_spawn):
		var new_enemy = enemy_prefabs[randi_range(0, enemy_prefabs.size() - 1)].instantiate()
		new_enemy.on_enemy_died.connect(enemy_died)
		
		var picked_pos = spawn_points[randi_range(0, spawn_points.size() - 1)]
		add_child(new_enemy)
		
		new_enemy.position = picked_pos.position
		
		current_enemies.append(new_enemy)
		
	enemies_to_spawn += enemies_to_add
	enemies_to_add += 1

func interval():
	$WaveInterval.start()

func enemy_died(enemy):
	current_enemies.erase(enemy)
	
	if (current_enemies.size() == 0):
		interval()
	
	print(enemy.name + " dead")
	print(current_enemies.size())

func _on_wave_interval_timeout() -> void:
	spawn_wave()

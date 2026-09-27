extends CSGBox3D

@export var door: Node3D
@export var button: Node3D

@onready var normal_door_pos = door.position
@onready var normal_button_pos = button.position

var door_tween: Tween
var btn_tween: Tween

@onready var wavemang = $"../../../WaveManager"

var activated = false

func _ready() -> void:
	activate()

func activate() -> void:
	if (activated):
		return
		
	if (door_tween):
		door_tween.kill()
	if (btn_tween):
		btn_tween.kill()
	
	$PreStartTimer.start()
	
	door_tween = create_tween()
	door_tween.tween_property(door, "position:y", position.y + 4, 3)
	
	btn_tween = create_tween()
	btn_tween.tween_property(button, "position:y", position.y - 4, 1.5)
	
	material.albedo_color = Color(1, 0, 0, 1)
	
	activated = true

func reset() -> void:
	if (door_tween):
		door_tween.kill()
	if (btn_tween):
		btn_tween.kill()
		
	door_tween = create_tween()
	door_tween.tween_property(door, "position:y", normal_door_pos.y, 0.3)	
	
	btn_tween = create_tween()
	btn_tween.tween_property(button, "position:y", normal_button_pos.y, 3)	
	
	activated = false
	material.albedo_color = Color(1, 1, 1, 1)

func _on_pre_start_timer_timeout() -> void:
	wavemang.spawn_wave()

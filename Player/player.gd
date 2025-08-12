extends CharacterBody2D

const SPEED = 300.0
var current_door = null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if current_door != null:
			current_door.send_info()
			
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

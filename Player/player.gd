extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed := 150.0
@onready var camera: Camera2D = $Camera2D

const IDLE_THRESHOLD = 5.0
var current_interactable = null
var current_door = null
var can_move = true

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if current_door:
			current_door.send_info()
		if current_interactable and len(current_interactable.dialogue_lines) != 0:
			DialogueManager.main(current_interactable.dialogue_lines)
		else:
			DialogueManager.clear_dialogue()
			
func _physics_process(delta: float) -> void:
	if not can_move:
		velocity.x = 0
		move_and_slide()
		animated_sprite.play("idle")
		return
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
	update_animation()

func update_animation():
	if abs(velocity.x) < IDLE_THRESHOLD:
		animated_sprite.play('idle')
	else:
		animated_sprite.play('walking')
		if velocity.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true

func _on_dialogue_started():
	can_move = false

func _on_dialogue_finished():
	can_move = true

func limit_camera(left_coordinate, right_coordinate):
	camera.limit_left = left_coordinate
	camera.limit_right = right_coordinate

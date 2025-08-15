extends Area2D

@export var flag: String
@export var value: bool

@export_group('Dialogue Settings')
@export var has_dialogue: bool
@export var dialogue_id: String

var is_dialogue_active = false

func _ready() -> void:
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)

func _on_body_entered(body: Node2D) -> void:
	body.current_event_area = self

func _on_body_exited(body: Node2D) -> void:
	if body.current_event_area == self:
		body.current_event_area = null

func interact(player:CharacterBody2D):
	var current_flag = Gamestate.read_flag(flag)
	if current_flag != value:
		Gamestate.set_flag(flag, value)
		is_dialogue_active = true
	if has_dialogue and is_dialogue_active:
		DialogueManager.dialogue_manager(dialogue_id)
		
func  _on_dialogue_finished():
	is_dialogue_active = false
	

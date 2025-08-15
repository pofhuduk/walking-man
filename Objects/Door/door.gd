extends Area2D

signal door_used

# Exporting object settings
@export var id: String
@export var is_locked: bool
@export_file("*.tscn") var target_room: String
@export var target_door: String
@onready var arrow: AnimatedSprite2D = $AnimatedSprite2D

var opened_first_time = false
var unlocked_flag_name: String
var key_flag_name: String

func _ready():
	unlocked_flag_name = id + '_unlocked'
	key_flag_name = id + '_has_key'
	if is_locked:
		if not Gamestate.read_flag(unlocked_flag_name):
			Gamestate.set_flag(unlocked_flag_name, false)
		if not Gamestate.read_flag(key_flag_name):
			Gamestate.set_flag(key_flag_name, false)
	else:
		Gamestate.set_flag(unlocked_flag_name, true)
		#Gamestate.set_flag(key_flag_name, true)

func _on_body_entered(body: Node2D) -> void:
	body.current_door = self
	arrow.show()

func _on_body_exited(body: Node2D) -> void:
	if body.current_door == self:
		body.current_door = null
		arrow.hide()
		
func interact(player: CharacterBody2D):
	print(Gamestate.read_flag(unlocked_flag_name))
	if not Gamestate.read_flag(unlocked_flag_name):
		if Gamestate.read_flag(key_flag_name):
			Gamestate.set_flag(unlocked_flag_name, true)
			DialogueManager.dialogue_manager('door_opened')
			opened_first_time = true
		else:
			DialogueManager.dialogue_manager('door_locked')
	elif opened_first_time:
		DialogueManager.clear_dialogue()
		opened_first_time = false
	else:
		door_used.emit(target_room, target_door, player)

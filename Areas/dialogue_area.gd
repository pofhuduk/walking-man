extends Area2D

# Exporting object settings
@export var id: String

func _on_body_entered(body: Node2D) -> void:
	body.current_dialogue = self

func _on_body_exited(body: Node2D) -> void:
	if body.current_dialogue == self:
		body.current_dialogue = null
		
func interact(player: CharacterBody2D):
	DialogueManager.dialogue_manager(id)

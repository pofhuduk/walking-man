extends Area2D

signal dialogue

@export var dialogue_lines: PackedStringArray

func _on_body_entered(body: Node2D) -> void:
	body.current_interactable = self

func _on_body_exited(body: Node2D) -> void:
	if body.current_interactable == self:
		body.current_interactable = null

func send_info():
	dialogue.emit()

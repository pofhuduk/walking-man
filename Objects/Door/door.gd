extends Area2D

signal door_used
@export var room: PackedScene
@export var door: String
var body

func _on_body_entered(body: Node2D) -> void:
	body.current_door = self
	self.body = body

func _on_body_exited(body: Node2D) -> void:
	if body.current_door == self:
		body.current_door = null

func send_info():
	door_used.emit(room, door, body)

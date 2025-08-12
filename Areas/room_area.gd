extends Area2D

@onready var left_wall: StaticBody2D = $CollisionShape2D/LeftWall
@onready var right_wall: StaticBody2D = $CollisionShape2D/RightWall



func _on_body_entered(body: Node2D) -> void:
	var x_left = left_wall.global_position.x
	var x_right = right_wall.global_position.x
	body.limit_camera(x_left, x_right)

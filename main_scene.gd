extends Node

@export_file("*.tscn") var start_room: String
@export var target_door: String
@onready var room_manager: Node = $RoomManager
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	if start_room:
		room_manager.load_room(start_room,target_door,player)

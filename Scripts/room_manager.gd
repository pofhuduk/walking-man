extends Node

func load_room(room: String, door: String, player: CharacterBody2D):
	if get_child_count() > 0:
		var old_room = get_child(0)
		old_room.queue_free()
	var room_scene = load(room)
	var new_room = room_scene.instantiate()
	add_child(new_room)
	for child in new_room.get_children():
		if child.is_in_group('door'):
			child.door_used.connect(Callable(self, "load_room"))
	var target_door = new_room.find_child(door)
	if target_door:
		var marker = target_door.get_node('Marker2D')
		player.global_position = marker.global_position
	else:
		print("Can't find door!")

extends Node

var event_flags: Dictionary = {
	'test' = false,
	'has_hall_key' = false
} 

var current_day = 1

func set_flag(flag: String, value):
	event_flags[flag] = value

func read_flag(flag: String):
	if event_flags.has(flag):
		return event_flags[flag]
	return false

func next_day():
	current_day += 1

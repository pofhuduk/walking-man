extends Node

signal dialogue_started
signal dialogue_finished

@onready var label: Label = $Control/Label
@onready var dialogue_box: Control = $Control

var current_line_index = 0
var lines

func _ready() -> void:
	label.text = 'Textbox is ready.'
	dialogue_box.hide()
	
func main(lines):
	if not lines:
		clear_dialogue()
		return
	if current_line_index == 0:
		self.lines = lines
		start_dialogue()
	else:
		if current_line_index >= len(lines):
			clear_dialogue()
			return
		else:
			show_line()
	current_line_index += 1

func start_dialogue():
	show_line()
	dialogue_box.show()
	dialogue_started.emit()
	
func show_line():
	label.text = lines[current_line_index]
	
func clear_dialogue():
	if dialogue_box.is_visible():
		current_line_index = 0
		dialogue_box.hide()
		dialogue_finished.emit()

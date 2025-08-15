extends Node

signal dialogue_started
signal dialogue_finished

@onready var label: Label = $Control/Label
@onready var dialogue_box: Control = $Control

const DIALOGUES_PATH = "res://Dialogue/dialogues.json"
var dialogue_database: Dictionary = {}
var current_line_index: int = 0
var dialogue_lines: Array = []

func dialogue_manager(id):
	if current_line_index == 0:
		get_dialogue(id)
	else:
		advance_dialogue()

func _ready() -> void:
	load_dialogues()
	label.text = 'Textbox is ready.'
	dialogue_box.hide()

func load_dialogues():
	# Check if file exists
	if not FileAccess.file_exists(DIALOGUES_PATH):
		print('dialogues.json not exists.')
		return
	# Read file
	var file = FileAccess.open(DIALOGUES_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	# JSON parsing
	var json = JSON.new()
	var error = json.parse(content)
	
	# Error handling
	if error == OK:
		var data_received = json.data
		dialogue_database = data_received
		print('Successfully read dialogues.json file.')
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())

func get_dialogue(id: String):
	# Checking is id valid
	if not dialogue_database.has(id): 
		return
	
	# Getting object and current day
	var object = dialogue_database[id]
	var current_day = str(Gamestate.current_day)		
	
	# Creating empty list for storing dialogue blocks
	var blocks = []
	
	# CONTROL
	if object.has(current_day):
		blocks = object[current_day]
	elif object.has('default'):
		blocks = object['default']
	# Object is not talking
	else: return	
	
	# Condition checking
	for block in blocks:
		var conditions = block['conditions']
		var all_conditions_met = true
		
		for condition in conditions:
			if Gamestate.read_flag(condition) != conditions[condition]:
				all_conditions_met = false
				break
		
		if all_conditions_met:
			start_dialogue(block['dialogue'])
			return

func start_dialogue(lines: Array):
	if lines.is_empty():
		return
	dialogue_lines = lines
	current_line_index = 0
	dialogue_box.show()
	show_current_line()
	current_line_index += 1
	dialogue_started.emit()

func advance_dialogue():
	if current_line_index < dialogue_lines.size():
		show_current_line()
	else:
		clear_dialogue()
		return
	current_line_index += 1

func clear_dialogue():
	if dialogue_box.is_visible():
		dialogue_lines = []
		current_line_index = 0
		dialogue_box.hide()
		dialogue_finished.emit()

func show_current_line():
	label.text = dialogue_lines[current_line_index]

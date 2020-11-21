extends Node

class InputState:
	var up = false
	var down = false
	var left = false
	var right = false
	var frame = 0

		
class InputRecord:
	var states = []
	var active_index = 0 # for replaying
	func _init():
		pass
	
	func are_states_equal(s1, s2):
		return s1.up == s2.up and \
			   s1.down == s2.down and \
			   s1.left == s2.left and \
			   s1.right == s2.right
	
	func add_state_if_changed(state):
		if states.empty():
			states.append(state)
		else:
			if not are_states_equal(states[-1], state):
				states.append(state)
	
	func update_for_frame(frame):
		if active_index + 1 == len(states):
			# no further states, so do not advance
			return
		elif states[active_index + 1].frame == frame:
			active_index += 1
			
	func get_active_up():
		return states[active_index].up
	func get_active_down():
		return states[active_index].down
	func get_active_left():
		return states[active_index].left
	func get_active_right():
		return states[active_index].right

var current_input_record
var ghost_records = []
var frame_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_input_record = InputRecord.new()
	
# to be called from active non-ghost player
func manual_update():
	# button state update
	var new_input_state = InputState.new()
	new_input_state.up = Input.is_action_pressed("ui_up")
	new_input_state.down = Input.is_action_pressed("ui_down")
	new_input_state.left = Input.is_action_pressed("ui_left")
	new_input_state.right = Input.is_action_pressed("ui_right")
	new_input_state.frame = frame_counter
	current_input_record.add_state_if_changed(new_input_state)
	
	# advance ghost records
	for gr in ghost_records:
		gr.update_for_frame(frame_counter)
	
	frame_counter += 1
	
func save_record_and_reset():
	for gr in ghost_records:
		gr.active_index = 0
	ghost_records.append(current_input_record)
	current_input_record = InputRecord.new()
	frame_counter = 0
	
func get_up(ghost_id):
	if ghost_id == -1:
		return current_input_record.states[-1].up
	else:
		return ghost_records[ghost_id].get_active_up()
		
func get_down(ghost_id):
	if ghost_id == -1:
		return current_input_record.states[-1].down
	else:
		return ghost_records[ghost_id].get_active_down()
		
func get_left(ghost_id):
	if ghost_id == -1:
		return current_input_record.states[-1].left
	else:
		return ghost_records[ghost_id].get_active_left()
		
func get_right(ghost_id):
	if ghost_id == -1:
		return current_input_record.states[-1].right
	else:
		return ghost_records[ghost_id].get_active_right()
	

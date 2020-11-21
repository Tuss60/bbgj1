extends Node

class InputState:
	var up = false
	var down = false
	var left = false
	var right = false
	var frame = 0

		
class InputRecord:
	var states = []
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

var current_input_record
var frame_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_input_record = InputRecord.new()
	
# to be called from active non-ghost player
func manual_update():
	var new_input_state = InputState.new()
	new_input_state.up = Input.is_action_pressed("ui_up")
	new_input_state.down = Input.is_action_pressed("ui_down")
	new_input_state.left = Input.is_action_pressed("ui_left")
	new_input_state.right = Input.is_action_pressed("ui_right")
	new_input_state.frame = frame_counter
	current_input_record.add_state_if_changed(new_input_state)
	frame_counter += 1
	
func get_up(ghost_id):
	if ghost_id == 0:
		return current_input_record.states[-1].up
	else:
		return false
		
func get_down(ghost_id):
	if ghost_id == 0:
		return current_input_record.states[-1].down
	else:
		return false
		
func get_left(ghost_id):
	if ghost_id == 0:
		return current_input_record.states[-1].left
	else:
		return false
		
func get_right(ghost_id):
	if ghost_id == 0:
		return current_input_record.states[-1].right
	else:
		return false
	

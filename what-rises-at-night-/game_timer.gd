extends Control

@onready var phase_timer =  $HBoxContainer/VBoxContainer/timer_text/phase_timer
@onready var timer_text = $HBoxContainer/VBoxContainer/timer_text
@onready var objective_text = $"HBoxContainer/VBoxContainer/current objective"









var phase : int = 0 
# 0 - timer paused // menus, pre game
# 1 - hiding phase 
# 2 - searching phase


var phase_time = 5


 
func _ready() -> void:
	
	
	
	
	phase = 0
	
	timer_text.text = "enter the house"
	objective_text.text = ""
	
	BakerVars.round_started = false
	




func _process(_delta: float) -> void:
	
	
	if phase == 0 and BakerVars.starting_round == true:
		
		
		
		
		
		
		BakerVars.starting_round = false
		BakerVars.round_started = true
		phase_timer.start()
		
	
	
	
	
	
	
	
	
	
	
	if BakerVars.round_started == true:
		update_label(phase_timer.time_left)
	
	
	
	
	
	pass



func _on_phase_timer_timeout() -> void:
	
	
	match phase:
		0:
			phase = 1
			phase_time = 10
			phase_timer.wait_time = phase_time
			update_label(phase_timer.time_left)
			phase_timer.start()
			objective_text.text = "hide the ingridients"
			
			
		1:
			
			phase = 2
			phase_time = 480
			phase_timer.wait_time = phase_time
			update_label(phase_timer.time_left)
			phase_timer.start()
			objective_text.text = "survive"
			BakerVars.round_started = true
			
			
			
		2:
			
			
			#play win night here
			pass





func update_label(seconds_left: float) -> void:
	var clamped: float = max(seconds_left, 0.0)
	var total_seconds: int = int(ceil(clamped))
	
	
	
	@warning_ignore("integer_division")
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	timer_text.text = "%02d:%02d" % [minutes, seconds]

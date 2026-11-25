extends Control

@onready var phase_timer = $timer_text/phase_timer
@onready var timer_text = $timer_text

var phase : int = 0 
# 0 - timer paused // menus, pre game
# 1 - hiding phase 
# 2 - searching phase


var phase_time: int = 5



func _ready() -> void:
	
	
	
	
	phase = 0
	
	
	phase_timer.wait_time = phase_time
	phase_timer.one_shot = true
	update_label(phase_time)
	phase_timer.start()








func _process(_delta: float) -> void:
	
	
	update_label(phase_timer.time_left)
	
	
	
	
	pass



func _on_phase_timer_timeout() -> void:
	
	
	match phase:
		
		
		0:
			phase = 1
			phase_time = 180
			phase_timer.wait_time = phase_time
			update_label(phase_timer.time_left)
			phase_timer.start()
			
			
			BakerVars.round_started = true
			
			
			
		1:
			
			phase = 2
			phase_time = 480
			phase_timer.wait_time = phase_time
			update_label(phase_timer.time_left)
			phase_timer.start()
			
			
			
			
			
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

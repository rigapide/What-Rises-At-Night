extends Node3D





@onready var head_point = $head



func _ready() -> void:
	
	
	
	pass
	

func _process(delta: float) -> void:
	
	
	head_point.global_position = BakerVars.baker_nav_agent_pos
	
	
	
	
	
	
	
	
	
	
	
	pass

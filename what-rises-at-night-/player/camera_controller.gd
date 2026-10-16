extends SpringArm3D

@export var mouse_sensitivity: float = 0.01


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


#camera rotation
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, -PI/2, PI/4)


#camera zoom
func _process(_delta: float) -> void:
	#locks zoom on inventory open
			#print(invopen)
	
	if Input.is_action_just_pressed("ScrollDown"):
		spring_length = spring_length + 0.5
	if Input.is_action_just_pressed("ScrollUp") and spring_length > 0:
		spring_length = spring_length - 0.5
	
	
	
	
	#zoom functionality
	if spring_length > 0:
		if Input.is_action_just_pressed("rclick"):
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if Input.is_action_just_released("rclick"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#enables first person mode
	if spring_length == 0:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#if invopen == true:
		
		
		
		pass

extends CharacterBody3D

const runspeed = 24
const SPEED = 12

const JUMP_VELOCITY = 4.5

@onready var camera = $SpringArm3D/Camera3D

var running: bool




@onready var flashlight = $SpringArm3D/Camera3D/SpotLight3D




func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	running = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * 4) * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	
	
	if Input.is_action_pressed("shift"):
		running = true
	if Input.is_action_just_released("shift"):
		running = false
	
	match running:
		true:
			if direction:
				velocity.x = direction.x * runspeed
				velocity.z = direction.z * runspeed
			else:
				velocity.x = move_toward(velocity.x, 0, runspeed)
				velocity.z = move_toward(velocity.z, 0, runspeed)
		false:
			
			
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	if Input.is_action_just_pressed("f"):
		toggle_flashlight()
	if Input.is_action_just_pressed("r"):
		global_position = Vector3(33.272,14.707,-1.029)
	
	
	
	
	move_and_slide()





func toggle_flashlight():
	if flashlight.visible == true:
		flashlight.visible = false
		
		
		
	elif flashlight.visible == false:
		flashlight.visible = true
		
		

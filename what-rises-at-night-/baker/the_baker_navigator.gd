extends CharacterBody3D




@onready var mover = $NavigationAgent3D

@onready var UpdateTimer = $"update timer"

const time_to_update = 0.2
const smoothing = 0.1

var update_time = 0.0
@export var speed = 1000

var target = null




func set_target(current_target = target.position):
	mover.set_target_position(current_target)

func move_to_nxt_spot(Delta: float, speed: float):
	
	update_time -= Delta 
	if update_time <= 0.0:
		update_time = time_to_update
		if target:
			set_target(target.position)
	
	
	if not is_on_floor():
		velocity += get_gravity() * Delta
		move_and_slide()
		return
	
	
	
	if mover.is_navigation_finished():
		return
	
	
	var next_pos = mover.get_next_path_position()
	var dir = (next_pos - global_position).normalized()
	dir.y = 0
	
	
	var forward = -global_transform.basis.z
	
	var new_dir = forward.slerp(dir, smoothing).normalized()
	look_at(global_position + new_dir, Vector3.UP)
	
	velocity = velocity.lerp(dir * speed * Delta, smoothing)
	
	move_and_slide()



func _ready() -> void:
	target = BakerVars.player

func _physics_process(delta: float) -> void:
	move_to_nxt_spot(delta, speed)

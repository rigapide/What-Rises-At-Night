extends CharacterBody3D




@onready var mover = $NavigationAgent3D

@onready var reset_timer = $"reset timer"

const time_to_update = 0.2
const smoothing = 0.1

var update_time = 0.0
@export var speed = 500

var target = null
@onready var VertTracker = $VertTracker


@onready var real_pos = $CollisionShape3D

@onready var updedect = $"VertTracker/Debug mesh/wall climbing rays/up"
@onready var downdedect = $"VertTracker/Debug mesh/wall climbing rays/down"
@onready var frontdedect = $"VertTracker/Debug mesh/wall climbing rays/forward"
@onready var backdedect = $"VertTracker/Debug mesh/wall climbing rays/backwards"
@onready var rightdedect = $"VertTracker/Debug mesh/wall climbing rays/right"
@onready var leftdedect = $"VertTracker/Debug mesh/wall climbing rays/left"

var floor: bool
var right_wall: bool
var left_wall: bool
var front_wall: bool
var back_wall: bool
var ceiling: bool


#region navigation

func set_target(current_target = target.position):
	mover.set_target_position(current_target)

func move_to_nxt_spot(Delta: float, _Speed: float = speed):
	
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
	
	




#other than floor surface nav


func _physics_process(delta: float) -> void:
	move_to_nxt_spot(delta, speed)
	
	
	#tells what surface is closest
	
	
	
	
	var right_collider = null
	var left_collider = null
	var up_collider = null
	var down_collider = null
	var forward_collider = null
	var back_collider = null
	
	
	
	
	match frontdedect.is_colliding():
		true:
			front_wall = true
		false:
			front_wall = false
	
	match backdedect.is_colliding():
		true:
			back_wall = true
		false:
			back_wall = false
	
	match downdedect.is_colliding():
		true:
			floor = true
		false:
			floor = false
	
	match updedect.is_colliding():
		true:
			ceiling = true
		false:
			ceiling = false
	
	match leftdedect.is_colliding():
		true:
			left_wall = true
			left_collider = leftdedect.get_collider()
		false:
			left_wall = false
	
	match rightdedect.is_colliding():
		true:
			right_wall = true
			right_collider = rightdedect.get_collider()
		false:
			right_wall = false
	
	
	if right_wall == true:
		if VertTracker.position.distance_to(right_collider.global_position) > 2:
			VertTracker.position.x = lerp(VertTracker.position.x, right_collider.position.x +2, delta )
	else:
		VertTracker.position.x = lerp(VertTracker.position.x,real_pos.position.x , delta)
	
	
	if left_wall == true:
		pass
	
	if ceiling == true:
		pass
	
	if floor == true:
		pass
	
	
	
	
	
	



#endregion

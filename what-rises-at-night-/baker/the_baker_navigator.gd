extends CharacterBody3D



var target = null

@onready var reset_timer = $"reset timer"

const time_to_update = 0.2
const smoothing = 0.1
var update_time = 0.0




@onready var mover = $NavigationAgent3D
@export var speed = 500
@export var turn_speed = 12
@export var preffered_height: float = 10
@export var dist_from_wall = 1




@onready var VertTracker = $VertTracker
@onready var rotation_marker = $"VertTracker/rotation marker"



@onready var downdedect = $"VertTracker/rotation marker/wall climbing rays/down"

@onready var nearestareashape = $"VertTracker/rotation marker/nearest area/CollisionShape3D"






var on_surface: bool
var climbing_mode: bool 


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
	
	on_surface = false



#other than floor surface nav


func _physics_process(delta: float) -> void:
	move_to_nxt_spot(delta)
	rotation_marker.look_at(get_closest_surface(7))
	
	
	
	if climbing_mode == false:
		
		
		if downdedect.is_colliding():
			on_surface = true
		else:
			on_surface = false
		
		
		
		
		if on_surface == false:
			VertTracker.global_position.y = VertTracker.global_position.y - 7 * delta
		if on_surface == true:
			
			#check if on wall and not just floor here
			
			climbing_mode = true
		
		
		
		
		
	
	if climbing_mode == true:
		
		
		
		
		
		
		
		
		
		pass
	





func get_closest_surface(radius: float) -> Vector3:
	var space_state := get_world_3d().direct_space_state
	
	var sphere := SphereShape3D.new()
	sphere.radius = radius
	
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = sphere
	params.transform = VertTracker.global_transform
	params.exclude = [self.get_rid()]
	params.collision_mask = 1
	params.collide_with_bodies = true
	
	
	
	
	var info := space_state.get_rest_info(params)
	if info.is_empty():
		return  Vector3.INF# No collision
		
	
	
	var contact_point: Vector3 = info["point"]
	@warning_ignore("unused_variable")
	var surface_normal: Vector3 = info["normal"]
	
	
	
	return contact_point



#endregion

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





@onready var true_pos = $CollisionShape3D

@onready var floor_detector = $"VertTracker/floor detector"
@onready var wall_detect = $"VertTracker/wall detector"
@onready var forward_detect = $"VertTracker/forward detector"
@onready var ceiling_detect = $"VertTracker/ceiling detector"

@onready var surface_detect = $"VertTracker/rotation marker/wall climbing rays/down"




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
	
	
	climbing_mode = true
	




func _physics_process(delta: float) -> void:
	
	
	#tracks distance from vertical nav agent from ground nav agent
	var lower_dist = VertTracker.global_position.distance_to(true_pos.global_position)
	
	var dist_to_ceiling
	
	
	var decision = randi_range(1, 10)
	
	
	
	
	
	#looks at nearest surface
	rotation_marker.look_at(get_closest_surface(7))
	
	# checks if currently on any surface
	if surface_detect.is_colliding():
		on_surface = true
	else:
		on_surface = false
		climbing_mode = false
	
	
	
	
	
	
	#move towards target if on floor and not in climbing mode
	if floor_detector.has_overlapping_bodies() == true and climbing_mode == false:
		
		
		move_to_nxt_spot(delta)
		
		
		if wall_detect.has_overlapping_bodies() == true:
			climbing_mode = true
	
	
	
	
	
	
	
	
	#fall when off ground and not in climbing mode
	if floor_detector.has_overlapping_bodies() == false and climbing_mode == false:
		
		if lower_dist > 2 and on_surface == false:
			VertTracker.global_position.y = VertTracker.global_position.y - 4 * delta
			move_to_nxt_spot(delta)
			
		if on_surface == true:
			climbing_mode = true
	
	
	
	
	
	
	
	
	
	#climbing logig here
	if floor_detector.has_overlapping_bodies() == false and climbing_mode == true:
		
		
		#add ceiling detector logic in this hunk// change preffered height based on ceiling height
		
		
		if on_surface == true:
			
			
			#bumper logic here
			
			if forward_detect.has_overlapping_bodies() == true and lower_dist > 2:
				VertTracker.global_position.y = VertTracker.global_position.y - 2 * delta
				
				
			elif floor_detector.has_overlapping_bodies() == false:
				VertTracker.global_position.y = lerp(VertTracker.global_position.y, preffered_height, delta)
				move_to_nxt_spot(delta)
			
			
			
			
			
			
		else: 
			pass
	
	if floor_detector.has_overlapping_bodies() == true and climbing_mode == true:
		
		
		if decision > 5 and on_surface and forward_detect.has_overlapping_bodies() == false:
			VertTracker.global_position.y = VertTracker.global_position.y + 2 * delta
			move_to_nxt_spot(delta)
		else:
			move_to_nxt_spot(delta)
	
	
	print(climbing_mode)

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

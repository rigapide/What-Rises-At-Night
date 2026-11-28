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

@onready var surface_detect = $"VertTracker/rotation marker/wall climbing rays/surface_detect" 

@onready var nearestareashape = $"VertTracker/rotation marker/nearest area/CollisionShape3D"




@onready var ingridient_detector = $"VertTracker/Ingridient detector"




var on_surface: bool
var climbing_mode: bool 

var wandering: bool
var holding_item: bool
var targeting_item: bool




func _ready() -> void:
	
	
	on_surface = false
	
	
	climbing_mode = true
	
	
	wandering = false
	holding_item = false
	targeting_item = false


#region navigation and targeting



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


func _physics_process(delta: float) -> void:
	
	
	
	
	
	var decision = randi_range(1, 10) # decision generator
	
	var wander_decision = randi_range(1, 20)
	
	
	
	
	
	
	
	
	if BakerVars.round_started == true:
		if wandering == true:
			
			match wander_decision:
				
				1:
					pass
				2:
					pass
				3:
					pass
				4:
					pass
				5:
					pass
				6:
					pass
				7:
					pass
				8:
					pass
				9:
					pass
				10:
					pass
				11:
					pass
				12:
					pass
				13:
					pass
				14:
					pass
				15:
					pass
				16:
					pass
				17:
					pass
				18:
					pass
				19:
					pass
				20:
					pass
			
		if wandering == false and targeting_item == false:
			
			
			
			target = BakerVars.player
			
			
			
	
	
	
	
	
	if ingridient_detector.has_overlapping_areas() and holding_item == false:
		
		var areas = ingridient_detector.get_overlapping_areas()
		
		target = areas[0]
		
		targeting_item = true
		
		
		
		
	
	
	if holding_item == true:
		targeting_item = false
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	#region vertical navigation stuff
	
	#tracks distance from vertical nav agent from ground nav agent
	var lower_dist = VertTracker.global_position.distance_to(true_pos.global_position)
	
	
	#updates location and rotation for visual module to track
	BakerVars.baker_nav_agent_pos = VertTracker.global_position
	
	
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
		
		if on_surface == true:
			
			#bumper logic here
			
			if forward_detect.has_overlapping_bodies() == true and lower_dist > 2:
				VertTracker.global_position.y = VertTracker.global_position.y - 8 * delta
				
				
			elif floor_detector.has_overlapping_bodies() == false:
				VertTracker.global_position.y = lerp(VertTracker.global_position.y, preffered_height - 2, delta)
				move_to_nxt_spot(delta)
			
		else: 
			pass
	
	if floor_detector.has_overlapping_bodies() == true and climbing_mode == true:
		
		
		if decision > 5 and on_surface and forward_detect.has_overlapping_bodies() == false:
			VertTracker.global_position.y = VertTracker.global_position.y + 2 * delta
			move_to_nxt_spot(delta)
		else:
			move_to_nxt_spot(delta)
	
	
	if ceiling_detect.is_colliding():
		
		var ceiling_height = ceiling_detect.get_collision_point()
		
		
		preffered_height = ceiling_height.y - 3
	
	#print(climbing_mode)
	#endregion 
	
	
	
	
	
	
	
	


#region targeting logic

func where_to_wander():
	
	
	
	pass

func set_target(current_target = target.position):
	mover.set_target_position(current_target)




#endregion




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
		return  Vector3.MODEL_FRONT# No collision
		
	
	
	
	
	var contact_point: Vector3 = info["point"]
	@warning_ignore("unused_variable")
	var surface_normal: Vector3 = info["normal"]
	
	
	
	return contact_point

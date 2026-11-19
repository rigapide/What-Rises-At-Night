extends CharacterBody3D




@onready var mover = $NavigationAgent3D

@onready var reset_timer = $"reset timer"

const time_to_update = 0.2
const smoothing = 0.1

var update_time = 0.0
@export var speed = 500

var target = null
@onready var VertTracker = $VertTracker
@onready var rotation_marker = $"VertTracker/rotation marker"

@onready var real_pos = $CollisionShape3D


@onready var downdedect = $"VertTracker/rotation marker/wall climbing rays/down"

@onready var nearestareashape = $"VertTracker/rotation marker/nearest area/CollisionShape3D"



var floor_cling: bool
var wall_cling: bool
var ceiling_cling: bool


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
	
	
	
	
	if downdedect.is_colliding():
		pass
	
	
	
	rotation_marker.look_at(get_closest_surface())
	
	#get_closest_surface()
	
	
	
	


#not lookint at point, looking at overall quordinate, possible fix is adding a marker at raycast collision than look at that

func get_closest_surface():
	
	var space_state = get_world_3d().direct_space_state
	
	
	var min_distance: float = 0.0
	
	
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = nearestareashape.shape
	query.transform = nearestareashape.global_transform
	query.collide_with_bodies = true
	query.collision_mask = 1
	query.exclude = [self.get_rid()]
	
	
	
	var detection_center = nearestareashape.global_position
	
	
	
	var collision_points = space_state.collide_shape(query)
	var closest_point: Vector3 = collision_points[0]
	print(collision_points.size())
	for i in collision_points:
		
		
		var static_body_point = i
		var dist_sq = detection_center.distance_squared_to(static_body_point)
		print(dist_sq)
		
		if dist_sq < min_distance:
			min_distance = dist_sq
			closest_point = static_body_point
		
	
	
	
	print(closest_point)
	return closest_point
	


#endregion

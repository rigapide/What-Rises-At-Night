extends Node


#targets
var player = null

var the_starter = null
var the_water = null
var the_flour = null
var the_yeast = null





var round_started: bool = false
var starting_round: bool = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("r"):
		starting_round = true


#nav data
var baker_nav_agent_pos: Vector3
var baker_nav_agent_rotation: Vector3

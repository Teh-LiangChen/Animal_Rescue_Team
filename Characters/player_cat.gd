extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

var input_direction = Vector2.ZERO

func _ready():
	update_animation_parameters(starting_direction)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return


func _physics_process(_delta):
	#Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	#Update velocity
	velocity = input_direction * move_speed
	
	#Move and Slide function uses velocity of character body to s=move character on map
	move_and_slide()
	
	pick_new_state()


func update_animation_parameters(move_input : Vector2):
	#Don't change animation parameters if there is no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position",move_input)
		animation_tree.set("parameters/Idle/blend_position",move_input)
		
#Choose state based on what is happening with the player
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func player():
	pass

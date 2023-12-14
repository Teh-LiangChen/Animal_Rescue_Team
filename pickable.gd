extends Node2D

@onready var state = ""
@onready var player_in_area = false


func _process(delta):
	if state == "stolen":
		$AnimatedSprite2D.play("StolenEgg")
	else:
		$AnimatedSprite2D.play("Egg")
		if player_in_area:
			if Input.is_action_just_pressed("ui_accept"):
				state = "stolen"


func _on_pickable_body_entered(body):
	if body.has_method("player"):
		player_in_area = true


func _on_pickable_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

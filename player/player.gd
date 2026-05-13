extends CharacterBody2D


@export var speed = 200.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
	position.x = clampf(position.x, 0.0, 360.0)
	position.y = clampf(position.y, 0.0, 640.0)

extends CharacterBody2D
class_name Player

@export var speed = 200.0

@onready var world: World = get_parent()
@onready var sprite_size: Vector2 = %PlayerSprite.texture.get_size()


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
	position.x = clampf(position.x, sprite_size.x, world.resolution.x - sprite_size.x)
	position.y = clampf(position.y, sprite_size.y * 2, world.resolution.y - sprite_size.y)

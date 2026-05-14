extends CharacterBody2D
class_name EnemyBase

@export var health: float = 100.0
@export var speed: float = 200.0
@export var direction_curve: Curve2D

var direction: Vector2 = Vector2.DOWN


func calculate_direction() -> Vector2:
	# calc dir by curve
	return Vector2.DOWN


func _physics_process(delta: float) -> void:
	direction = calculate_direction()
	velocity = direction * speed
	move_and_slide()

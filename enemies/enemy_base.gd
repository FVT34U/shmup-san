extends CharacterBody2D
class_name EnemyBase

@export var health: float = 100.0
@export var speed: float = 200.0
@export var direction_curve: Curve2D

@onready var world: World = get_parent()
@onready var hurt_box: Area2D = %HurtBox

var direction: Vector2 = Vector2.DOWN
var cur_health: float = 100.0
var can_move: bool = true

func calculate_direction() -> Vector2:
	# calc dir by curve
	return Vector2.DOWN


func take_damage(instigator: Node2D, damage: float):
	if cur_health <= 0.0: return
	
	cur_health = maxf(0.0, cur_health - damage)
	
	if cur_health <= 0.0:
		queue_free()
		return


func _on_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage(self, 1.0)
	queue_free()
	return


func _ready() -> void:
	cur_health = health
	
	hurt_box.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if not can_move: return
	direction = calculate_direction()
	velocity = direction * speed
	move_and_slide()

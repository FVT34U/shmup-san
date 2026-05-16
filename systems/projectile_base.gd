extends CharacterBody2D
class_name ProjectileBase

@export var speed: float = 500.0
@export var lifetime: float = 1.0
@export var damage: float = 25.0

@onready var hurt_box: Area2D = %HurtBox

var pool: ObjectPool = null
var can_move: bool = false


func init_to_pool(pool_ref: ObjectPool):
	if !pool_ref: push_error("Pool is null")
	pool = pool_ref
	
	return


func awake():
	can_move = true
	visible = true
	
	return


func sleep():
	can_move = false
	visible = false
	
	return


func process_lifetime():
	await get_tree().create_timer(lifetime).timeout
	if pool: pool.return_object_to_pool(self)
	
	return


func _on_body_entered(body: Node2D):
	if body.has_method("take_damage") and pool:
		body.take_damage(pool.pool_owner, damage)
	if pool: pool.return_object_to_pool(self)


func _ready() -> void:
	hurt_box.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if not can_move: return
	velocity = Vector2.UP * speed
	move_and_slide()

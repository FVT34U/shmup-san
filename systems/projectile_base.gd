extends CharacterBody2D
class_name ProjectileBase

@export var speed: float = 500.0
@export var lifetime: float = 1.0

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
	pool.return_object_to_pool(self)
	
	return


func _physics_process(delta: float) -> void:
	if not can_move: return
	velocity = Vector2.UP * speed
	move_and_slide()

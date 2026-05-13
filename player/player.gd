extends CharacterBody2D
class_name Player

@export var speed: float = 200.0
@export var health: int = 3
@export var attack_speed: float = 0.5

@onready var world: World = get_parent()
@onready var sprite_size: Vector2 = %PlayerSprite.texture.get_size()
@onready var pool: ObjectPool = %ProjectilePool
@onready var shoot_point: Marker2D = %ShootPoint

var can_attack: bool = true


func attack():
	var projectile = pool.get_object_from_pool()
	projectile.global_position = shoot_point.global_position
	projectile.awake()
	return


func disable_attack_for_time(disable_time: float):
	pass


func _ready() -> void:
	pool.init_pool(world)
	await get_tree().create_timer(1.0).timeout
	attack()
	# set timer to call attack


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	position.x = clampf(position.x, sprite_size.x, world.resolution.x - sprite_size.x)
	position.y = clampf(position.y, sprite_size.y * 2, world.resolution.y - sprite_size.y)

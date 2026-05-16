extends CharacterBody2D
class_name Player

@export var speed: float = 200.0
@export var health: float = 3.0
@export var attack_speed: float = 0.5

@onready var world: World = get_parent()
@onready var sprite_size: Vector2 = %PlayerSprite.texture.get_size()
@onready var pool: ObjectPool = %ProjectilePool
@onready var shoot_point: Marker2D = %ShootPoint
@onready var attack_timer: Timer = %AttackTimer

var can_attack: bool = true
var cur_health: float = 3.0

func attack():
	if not can_attack: return
	
	var projectile = pool.get_object_from_pool()
	projectile.global_position = shoot_point.global_position
	projectile.awake()
	projectile.process_lifetime()
	
	return


func disable_attack_for_time(disable_time: float):
	can_attack = false
	await get_tree().create_timer(disable_time).timeout
	can_attack = true
	
	return


func take_damage(instigator: Node2D, damage: float):
	if cur_health <= 0.0: return
	
	cur_health = maxf(0.0, cur_health - damage)
	
	if cur_health <= 0.0:
		queue_free()
		return


func _ready() -> void:
	cur_health = health
	
	pool.init_pool(world, self)
	
	attack_timer.one_shot = false
	attack_timer.autostart = false
	
	attack_timer.timeout.connect(attack)
	attack_timer.start(attack_speed)


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	position.x = clampf(position.x, sprite_size.x, world.resolution.x - sprite_size.x)
	position.y = clampf(position.y, sprite_size.y * 2, world.resolution.y - sprite_size.y)
	
	if Input.is_action_just_pressed("space"):
		disable_attack_for_time(10.0)

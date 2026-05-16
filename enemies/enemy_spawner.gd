extends EnemyShooter
class_name EnemySpawner


@export var enemy_to_spawn: PackedScene = null
@export var enemy_count: int = 3

var spawn_idx: int = 0


func attack():
	if not can_attack: return
	
	if spawn_idx >= enemy_count: 
		queue_free()
		return
	
	var enemy = enemy_to_spawn.instantiate() as Node2D
	enemy.global_position = global_position
	world.add_child(enemy)
	
	spawn_idx += 1
	return


func _ready() -> void:
	super._ready()
	can_move = false

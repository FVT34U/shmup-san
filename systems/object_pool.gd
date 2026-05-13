extends Node
class_name ObjectPool

@export var object: PackedScene
@export var pool_size: int = 1000

var pool: Array[Node2D] = []
var _object_script: Script = null


func init_pool(world: World):
	var temp := object.instantiate()
	_object_script = temp.get_script()
	temp.free()
	
	for i in range(pool_size):
		var inst := object.instantiate() as Node2D
		if inst.has_method("init_to_pool"):
			inst.init_to_pool(self)
		inst.global_position = Vector2(-500, -500)
		world.add_child.call_deferred(inst)
		pool.append(inst)


func get_object_from_pool() -> Node2D:
	if pool.size() == 0: return null
	return pool.pop_at(randi_range(0, pool.size() - 1))


func return_object_to_pool(object_ref: Node2D):
	if object_ref == null:
		push_error("Pool: got null")
		return false

	if object_ref.get_script() != _object_script:
		push_error("Pool: wrong type — expected %s, got %s" % [
			_object_script.resource_path,
			object_ref.get_script().resource_path
		])
		return false

	if pool.has(object_ref):
		push_warning("Pool: object already in pool")
		return false

	object_ref.global_position = Vector2(-500, -500)
	object_ref.sleep()
	pool.append(object_ref)
	return true

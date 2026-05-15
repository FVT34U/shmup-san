extends EnemyBase
class_name EnemyShooter

@export var attack_speed: float = 1.0

@onready var attack_timer: Timer = %AttackTimer

var can_attack: bool = true


func attack():
	if not can_attack: return


func _ready() -> void:
	attack_timer.autostart = false
	attack_timer.one_shot = false
	attack_timer.timeout.connect(attack)
	attack_timer.start(attack_speed)

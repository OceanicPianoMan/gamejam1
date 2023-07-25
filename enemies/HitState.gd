extends State

class_name HitState

@export var damageable : Damageable
@export var dead_state : State
@export var dead_animation_node : String = "death"
@export var hit_animation_node : String = "hit"
@export var knockback_speed : float = 100.0
@export var return_state : State

@export var knockback_velocity : Vector2 = Vector2(100,0)

@onready var timer : Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_enter():
#	character.velocity = knockback_velocity
	timer.start()

func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	if(damageable.health > 0):
		character.velocity = knockback_speed * knockback_direction
		playback.travel(hit_animation_node)
		emit_signal("interrupt_state", self)
	else:
		emit_signal("interrupt_state", dead_state)
		playback.travel(dead_animation_node)

func on_exit():
	playback.travel(hit_animation_node)
	character.velocity = Vector2.ZERO
	


func _on_timer_timeout() -> void:
	next_state = return_state

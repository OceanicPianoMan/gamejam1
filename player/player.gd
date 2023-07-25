extends CharacterBody2D

class_name Player

@export var speed : float = 200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var npc_in_range = false
var dialouge_location : String = "res://main.dialogue"

signal facing_direction_changed(facing_right : bool)

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine

func _ready():
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x != 0 && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if npc_in_range == true:
		if Input.is_action_just_pressed("interact"):
			print("Interact button worked")
			DialogueManager.show_example_dialogue_balloon(load(dialouge_location), "start")
			return
	
	move_and_slide()
	update_animation_parameters()
	update_facing_direction()

func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
	emit_signal("facing_direction_changed", !sprite.flip_h)


func _on_detection_area_body_entered(body):
	if body.has_method("interact"):
		print("in range worked")
		npc_in_range = true


func _on_detection_area_body_exited(body):
	if body.has_method("interact"):
		print("not in range")
		npc_in_range = false

extends CheckButton

@export var transitioner : Transitioner 


func _on_toggled(button_pressed: bool) -> void:
	transitioner.set_next_animation(button_pressed)

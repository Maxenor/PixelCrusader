extends Node2D

const SPEED:int = 60
var direction:int = 1
var can_change_direction: bool = true
@onready var raycast_right: RayCast2D = $RayCastRight
@onready var raycast_left: RayCast2D = $RayCastLeft
@onready var raycast_down: RayCast2D = $RayCastDown
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not raycast_down.is_colliding() or raycast_left.is_colliding() or raycast_right.is_colliding():
		if can_change_direction:
			direction *= -1
			animated_sprite.flip_h = !animated_sprite.flip_h
			can_change_direction = false
			await get_tree().create_timer(0.5).timeout  # Adjust the delay as needed
			can_change_direction = true
	position.x += direction * SPEED * delta 

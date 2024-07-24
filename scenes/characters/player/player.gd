extends CharacterBody2D

const SPEED: float = 130.0
const JUMP_VELOCITY: float = -300.0
const MAX_JUMPS: int = 2
const GRAVITY: float = 980.0
var jump_count: int = 0
const ROLL_SPEED: float = 200
const ROLL_DURATION: float = 0.5
var is_rolling: bool = false
var roll_timer: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		jump_count = 0

	# Handle jump
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	
	# Get the input direction: -1, 0, 1
	var direction: int = Input.get_axis("move_left", "move_right")
	
	# if roll key pressed start rolling timer
	if Input.is_action_just_pressed("roll") and not is_rolling and is_on_floor():
		is_rolling = true
		roll_timer = ROLL_DURATION
	
	# decrease roll timer
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false

	# Flip the sprite based on movement direction
	if direction != 0:
		animated_sprite.flip_h = direction < 0
	
	# Play appropriate animation
	if is_rolling:
		animated_sprite.play("roll")
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	# Apply horizontal movement
	if is_rolling:
		# determine side to roll to based on sprite flip
		velocity.x = (1 if animated_sprite.flip_h == false else -1) * ROLL_SPEED
	else:
		velocity.x = direction * SPEED

	# Apply movement to the character
	move_and_slide()

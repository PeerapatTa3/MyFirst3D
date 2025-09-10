extends CharacterBody3D

signal squashed

# Minimum speed of the mob in meters per second.
@export var min_speed = 3
# Maximum speed of the mob in meters per second.
@export var max_speed = 6

func _physics_process(_delta):
	move_and_slide()

func initialize(start_position: Vector3, player_position: Vector3) -> void:
	# Keep mob on ground
	start_position.y = -1.0

	# Copy player position but flatten Y so mob looks horizontally
	var target = player_position
	target.y = start_position.y

	# Place mob and rotate only around Y
	look_at_from_position(start_position, target, Vector3.UP)

	# Calculate direction toward player, ignoring vertical difference
	var direction = (target - start_position).normalized()

	velocity = direction * randf_range(min_speed, max_speed)



func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()

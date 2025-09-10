extends CharacterBody3D

signal squashed

# Minimum speed of the mob in meters per second.
@export var min_speed = 3
# Maximum speed of the mob in meters per second.
@export var max_speed = 6

func _physics_process(_delta):
	move_and_slide()

func initialize(start_position: Vector3, player_position: Vector3) -> void:
	# Place the mob at the spawn point and rotate it to face the player
	look_at_from_position(start_position, player_position, Vector3.UP)

	# Calculate the direction toward the player
	var direction = (player_position - start_position).normalized()

	# Set velocity toward the player
	velocity = direction * randf_range(min_speed,max_speed)

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()

extends CharacterBody3D

signal hit

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(global_transform.origin + (direction * -1), Vector3.UP)

	# Ground movement
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical movement
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			target_velocity.y = jump_impulse
		else:
			target_velocity.y = 0
	else:
		target_velocity.y -= fall_acceleration * delta

	# Apply velocity and move
	velocity = target_velocity
	move_and_slide()

	# Handle collisions (after movement)
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue

		if collision.get_collider().is_in_group("mob"):
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				var mob = collision.get_collider()
				mob.squash()
				target_velocity.y = bounce_impulse
				break

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	print("mob entered")
	die()

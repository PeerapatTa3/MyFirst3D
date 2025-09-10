extends Node

@export var mob_scene: PackedScene

func _ready():
	$UI/Retry.hide()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Pass the spawn and player position into the mob
	var player_position = $Player.position
	var spawn_position = mob_spawn_location.position
	spawn_position.y = 0 
	mob.initialize(spawn_position, player_position)


	# Spawn the mob by adding it to the scene
	mob.squashed.connect($UI/ScoreLabel._on_mob_squashed.bind())
	add_child(mob)

func _on_player_hit() -> void:
	$UI/Retry.show()
	$MobTimer.stop()

func _on_button_pressed() -> void:
	if $UI/Retry.visible:
		get_tree().reload_current_scene()

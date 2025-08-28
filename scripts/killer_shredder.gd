extends Area2D

@onready var timer = $Timer
@onready var shredder = $"."

func _process(delta: float) -> void:
	shredder.position.y -= delta * 50

func _on_body_entered(body: CharacterBody2D) -> void:
	print("Shredded :(")
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	print("chicken jockey")

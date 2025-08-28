extends Node2D

@onready var timer: Timer = $Timer



func _ready() -> void:
	# If autostart is OFF, uncomment this:
	timer.start()
	print("Death screen started")

func _on_timer_timeout() -> void:
	print("Returning to game...")
	get_tree().change_scene_to_file("res://scenes/game.tscn")

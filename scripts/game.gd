extends Node2D

@export var coin_scene: PackedScene
@export var platform_scene: PackedScene
@export var min_x: float = -300
@export var max_x: float = 300
@export var vertical_gap: float = 50
@export var num_platforms: int = 200
@export var coin_gap: float = 20
@export var coins_spawned: int = 50

var coins = []
var platforms = []
var highest_y = 0

func _ready():
	# Spawn initial platforms
	for i in range(num_platforms):
		spawn_platform(-i * vertical_gap)
	for i in range(coins_spawned):
		spawn_coin(-i * coin_gap)

func spawn_coin(y_pos: float):
	var coin = coin_scene.instantiate()
	var x_pos = randf_range(min_x, max_x)
	coin.position = Vector2(x_pos, y_pos)
	add_child(coin)
	coins.append(coin)
	highest_y = min(highest_y, y_pos)

func spawn_platform(y_pos: float):
	var platform = platform_scene.instantiate()
	var x_pos = randf_range(min_x, max_x)
	platform.position = Vector2(x_pos, y_pos)
	add_child(platform)
	platforms.append(platform)
	highest_y = min(highest_y, y_pos)

func _process(delta):
	var player = get_node("Player")  # change path to your actual player
	# When player gets close to the highest platform, spawn more
	if player.position.y < highest_y + 400: 
		spawn_platform(highest_y - vertical_gap)
	
	# Remove platforms that are far below the player
	for p in platforms:
		if p.position.y > player.position.y + 600:
			p.queue_free()
			platforms.erase(p)

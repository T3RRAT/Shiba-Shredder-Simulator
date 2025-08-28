extends Node2D

@export var coin_scene: PackedScene
@export var platform_scene: PackedScene
@export var min_x: float = -300
@export var max_x: float = 300
@export var vertical_gap: float = 50
@export var num_platforms: int = 200
@export var coin_gap: float = 20
@export var coins_spawned: int = 20

var coins = []
var platforms = []
var highest_y = 0


func _ready():
	# Spawn initial platforms
	for i in range(coins_spawned):
		spawn_coin(-i * coin_gap)

func spawn_coin(y_pos: float):
	var coin = coin_scene.instantiate()
	var x_pos = randf_range(min_x, max_x)
	coin.position = Vector2(x_pos, y_pos)
	add_child(coin)
	coins.append(coin)
	highest_y = min(highest_y, y_pos)

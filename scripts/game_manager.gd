extends Node
@onready var score_label = $"../CanvasLayer"
var starting_y : float
var highest_y : float
var saved_highest_y : float
var coin_count = 0

func update_coin_count():
	coin_count =+ 1

func update_score_label():
	var score = int(starting_y - highest_y + coin_count * 100)   # difference from start position
	var best_score = int(starting_y - saved_highest_y)
	score_label.text = "Score: %d | Best: %d" % [score, best_score]

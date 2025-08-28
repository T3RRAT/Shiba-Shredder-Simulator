extends Area2D
@onready var player = $"../../Player"
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("WE GETTING RICHHH BABY")
		body.addCoin()
		animation_player.play("Coin_Pickup")

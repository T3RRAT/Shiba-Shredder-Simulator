extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const MAX_JUMP_VELOCITY = -400
const SIDE_JUMP_VELOCITY = -300
const SIDE_JUMP_SPEED = 100
const SIDE_JUMP_SPEED_MAX = 300
const DROP_SPEED = 50

var current_speed: float = 0.0
var max_speed: float = 300.0
var acceleration: float = 600.0   # how quickly we build up speed
var deceleration: float = 400.0   # how quickly we slow down if no input

var is_holding = false
var current_hold : Area2D = null

@onready var playerHitbox = $Hitbox
@onready var belowPlatform = $"Below Platform/StaticBody2D"
#@onready var detector: Area2D = $AreaDetector
@onready var cam = $Camera2D
@onready var score_label = $"../CanvasLayer/Score"
var starting_y : float
var highest_y : float
var saved_highest_y : float
var coinCollected = 0

func addCoin():
	coinCollected = coinCollected + 1
	update_score_label()

func _ready() -> void:
	saved_highest_y = load_highest_y()
	highest_y = global_position.y
	starting_y = global_position.y
	update_score_label()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var input_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input_dir != 0:
		# Accelerate toward the input direction
		current_speed = clamp(current_speed + input_dir * acceleration * delta,-max_speed,max_speed)
	else:
		# Decelerate back to 0 when no input
		if current_speed > 0:
			current_speed = max(current_speed - deceleration * delta, 0)
		elif current_speed < 0:
			current_speed = min(current_speed + deceleration * delta, 0)
	
	# Apply horizontal movement
	velocity.x = current_speed


	# Handle jump.
	if is_on_floor():
		velocity.y = MAX_JUMP_VELOCITY
	var speed = velocity.length()   # how fast the player is moving
	# map speed -> zoom (higher speed = zoom out more)
	var min_zoom = Vector2(6, 6)     # normal zoom
	var max_zoom = Vector2(1, 1)     # fully zoomed out
	var max_speed = 400              # speed at which zoom reaches max
	# clamp between min_zoom and max_zoom
	var t = clamp(speed / max_speed, 0.7, 2.0)
	var target_zoom = min_zoom.lerp(max_zoom, t)
	# smooth the transition
	cam.zoom = cam.zoom.lerp(target_zoom, 0.5 * delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta / 2


	if global_position.y < highest_y:   # "Up is smaller y"
		highest_y = global_position.y
		update_score_label()
		
		if highest_y < saved_highest_y: # Check against saved best
			saved_highest_y = highest_y
			save_highest_y(saved_highest_y)


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	move_and_slide()

func save_highest_y(value: float):
	var file = FileAccess.open("user://highest_y.save", FileAccess.WRITE)
	file.store_var(value)
	file.close()

func load_highest_y() -> float:
	if FileAccess.file_exists("user://highest_y.save"):
		var file = FileAccess.open("user://highest_y.save", FileAccess.READ)
		var value = file.get_var()
		file.close()
		return value
	return global_position.y   # fallback if no save yet

func update_score_label():
	var score = int(starting_y - highest_y + coinCollected * 100)   # difference from start position
	var best_score = int(starting_y - saved_highest_y)
	score_label.text = "Score: %d | Best: %d | Coins: %d" % [score, best_score, coinCollected]


	

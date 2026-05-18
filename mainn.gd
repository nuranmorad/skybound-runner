extends Node2D

# =========================
#  PRELOADS & GLOBAL VARS
# =========================

# Preload obstacles
var stump: PackedScene      = preload("res://stump.tscn")
var rock: PackedScene       = preload("res://rock.tscn")
var barrel: PackedScene     = preload("res://barrel.tscn")
var stone: PackedScene      = preload("res://stone.tscn")
var stoneblock: PackedScene = preload("res://stoneblock.tscn")

var obstacle_types := [
	stump,
	rock,
	barrel,
	stone,
	stoneblock
]

var obstacles: Array = []

const player_START_POS := Vector2(-159, 282)
const cam_START_POS    := Vector2(576, 324)

var difficulty: int = 0
const MAX_DIFFICULTY: int = 2

var speed: float
const score_modifier: int = 10
const speed_modifier: int = 5000

const start_speed: float = 10.0
const max_speed: int = 25
var high_score: float = 0.0
var screen_size: Vector2i
var score: float = 0.0

var groundheight: float = 0.0
var ground_top: float = 0.0

# Small tweak to push obstacles slightly into the ground if needed
const OBSTACLE_Y_OFFSET: float = 250.0

var game_running: bool = false
var last_obs: Node2D = null

# Coins
var coin_scene: PackedScene = preload("res://coin.tscn")
var coins: Array = []
var coins_collected: int = 0


# =========================
#  LIFECYCLE
# =========================

func _ready() -> void:
	#randomize()
	screen_size = get_window().size
	_update_ground_top()
	$gameover.get_node("Button").pressed.connect(new_game)

	new_game()


# =========================
#  GROUND
# =========================

func _update_ground_top() -> void:
	var ground_sprite: Sprite2D = $ground.get_node("Sprite2D")
	var tex_size: Vector2 = ground_sprite.texture.get_size() * ground_sprite.scale

	groundheight = tex_size.y

	# If the ground sprite is centered, its position is the middle.
	# If not centered, position is usually at the top-left, so top = y.
	if ground_sprite.centered:
		ground_top = ground_sprite.global_position.y - groundheight / 2.0
	else:
		ground_top = ground_sprite.global_position.y

# =========================
#  GAME CONTROL
# =========================

func new_game() -> void:
	# Clear any old obstacles
	for o in obstacles:
		if is_instance_valid(o):
			o.queue_free()
	obstacles.clear()
	last_obs = null

	# Clear old coins
	for c in coins:
		if is_instance_valid(c):
			c.queue_free()
	coins.clear()
	coins_collected = 0
	#if $HUD.has_node("coinslabel"):
	#	$HUD/coinLabel.text = "COINS:0"

	score = 0.0
	show_score()
	show_coinscore()
	show_highscore()
	game_running = false
	get_tree().paused = false

	difficulty = 0

	$SHE.position = player_START_POS
	$SHE.velocity = Vector2(0, 0)
	$Camera2D.position = cam_START_POS

	# Only reset X so the Y (height) stays as designed in the scene
	$ground.position.x = 0
	_update_ground_top()

	$HUD/startLabel.show()
	$gameover.hide()


func _process(delta: float) -> void:
	if game_running:
		# Update speed with cap
		speed = start_speed + score / speed_modifier
		if speed > max_speed:
			speed = max_speed

		adjust_difficulty()
		generate_obs()

		$SHE.position.x += speed
		$Camera2D.position.x += speed
		score += speed
		show_score()

		# Move ground to simulate endless floor
		if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			$ground.position.x += screen_size.x
			# Y doesn't change, so no need to recompute ground_top here

		# Remove obstacles that have gone off screen
		for obs in obstacles.duplicate():
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)

		# Remove coins that have gone off screen
		for coin in coins.duplicate():
			if coin.position.x < ($Camera2D.position.x - screen_size.x):
				if is_instance_valid(coin):
					coin.queue_free()
				coins.erase(coin)
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD/startLabel.hide()


# =========================
#  SPAWNING
# =========================

func generate_obs() -> void:
	# If no obstacles yet OR last obstacle is far enough behind, spawn new ones
	if obstacles.is_empty() or (last_obs != null and last_obs.position.x < score + randi_range(300, 500)):
		var obs_type: PackedScene = obstacle_types[randi() % obstacle_types.size()]

		var max_obs: int = difficulty + 1
		var count: int = randi_range(1, max_obs)  # always at least 1 obstacle

		for i in range(count):
			var obs: Node2D = obs_type.instantiate()

			var sprite: Sprite2D = obs.get_node("Sprite2D")
			var obs_height: float = sprite.texture.get_size().y * sprite.scale.y

			var obs_x: float = screen_size.x + score + 100 + (i * 100)

			# Bottom of obstacle should sit on the ground:
			# if sprite is centered, bottom = obs_y + obs_height/2
			var obs_y: float = ground_top - obs_height / 2.0 + OBSTACLE_Y_OFFSET

			obs.position = Vector2(obs_x, obs_y)

			# Connect collision if the scene uses body_entered (e.g. Area2D)
			if obs.has_signal("body_entered"):
				obs.body_entered.connect(hit_obs)

			add_child(obs)
			obstacles.append(obs)
			last_obs = obs

			# --- optionally spawn a coin above this obstacle ---
			if randi_range(0, 100) < 40: # 40% chance
				var coin: Area2D = coin_scene.instantiate()
				coin.position = obs.position + Vector2(0, -80) # adjust height if needed

				# connect coin pickup, pass which coin it is
				coin.body_entered.connect(_on_coin_body_entered.bind(coin))

				add_child(coin)
				coins.append(coin)


func add_obs(obs: Node2D, x: int, y: int) -> void:
	obs.position = Vector2(x, y)
	if obs.has_signal("body_entered"):
		obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)


# =========================
#  COLLISIONS
# =========================

func hit_obs(body: Node) -> void:
	if body.name == "SHE":
		$SHE.get_node("oversound").play()
		game_over()


func _on_coin_body_entered(body: Node, coin: Node2D) -> void:
	if body.name != "SHE":
		return
	coins_collected += 1
	$HUD/coinlabel.text = "COINS: " + str(coins_collected)

	if is_instance_valid(coin):
		coins.erase(coin)
		coin.queue_free()


# =========================
#  HUD / SCORE / DIFFICULTY
# =========================

func show_score() -> void:
	$HUD/scoreLabel.text = "SCORE: " + str(int(score) / score_modifier)

func show_highscore() -> void:
	$HUD/highscorelabel.text = "High Score: " + str(int(high_score) / score_modifier)
func show_coinscore() -> void:
	$HUD/coinlabel.text = "COIN: " + str(coins_collected)

func adjust_difficulty() -> void:
	difficulty = int(score / speed_modifier)
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY


# =========================
#  OBSTACLE CLEANUP
# =========================

func remove_obs(obs: Node2D) -> void:
	if is_instance_valid(obs):
		obs.queue_free()
	obstacles.erase(obs)


# =========================
#  GAME OVER / HIGH SCORE
# =========================

func game_over() -> void:
	check_high_score()
	get_tree().paused = true
	game_running = false
	#$SHE/sound3.play()
	$gameover.show()


func check_high_score() -> void:
	if score > high_score:
		high_score = score
		$HUD/highscorelabel.text = "High SCORE: " + str(int(high_score) / score_modifier)

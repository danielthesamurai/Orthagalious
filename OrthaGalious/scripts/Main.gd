extends Node2D

#unpack scene variables
const bullet = preload("res://scenes/Bullet.tscn")
const simple_enemy = preload("res://scenes/simple_enemy.tscn")
const enemy_ship = preload("res://scenes/enemy_ship.tscn")
const UFO_enemy = preload("res://scenes/UFO.tscn")

#get node variables
onready var b_timer = get_node("bullet_timer")
onready var sfx_laser = get_node("fire_laser")
onready var enemy_timer = get_node("simple_enemy_spawner")
onready var base = get_node("Base")
onready var base_anim = get_node("Base/AnimationPlayer")
onready var sfx_base = get_node("Base/AudioStreamPlayer")
onready var global_script_node = get_node("/root/global_score")

#set the number variables
var asteroid_speed = 100
var level = 1
var enemy_choice = 0
var too_hot = false
var green = 1
var blue = 1
var ship_speed = 1
var UFO_main_speed = 20
var score = 0
var game_loop = true

func _ready():
	#fade in
	$CanvasLayer/fade_rect/AnimationPlayer.play("fade")
	score = 0

func _process(delta):
	#window functions
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept"):
		OS.window_fullscreen = !OS.window_fullscreen
		
	#handle firing bullets
	fire_bullet("ui_up",400,250,0,"up")
	fire_bullet("ui_down",400,350,180,"down")
	fire_bullet("ui_left",350,300,275,"left")
	fire_bullet("ui_right",450,300,90,"right")
	#cool down animation handling using colors
	if green <= 0 and blue <= 0:
		too_hot = true
	if green >= 1 and blue >= 1:
		too_hot = false
	if is_instance_valid(base_anim):
		if Input.is_action_just_pressed("x_key") and !base_anim.is_playing(): 
			base_anim.play("spin")
			sfx_base.play()
		if base_anim.is_playing():
			if blue <= 1 and green <= 1:
				blue += 0.02
				green += 0.02
				
	if is_instance_valid(base):
		base.modulate = Color(1,green,blue)
		
	#code for handling the scorekeeping
	if game_loop == true:
		if OS.vsync_enabled == true:
			score += int(delta * 100)
		else:
			score += int(delta * 2000)
		$Score.text = str(score)
	
	
	
#function for instancing and firing bullets in different directions
func fire_bullet(arrow_key,bx,by,dirrot,dirvar):
	if Input.is_action_just_pressed(arrow_key) and b_timer.time_left <= 0.01:
		if too_hot == false:
			if is_instance_valid(base_anim):
				if !base_anim.is_playing():
					var binstance = bullet.instance()
					binstance.position.x = bx
					binstance.position.y = by
					binstance.rotate(deg2rad(dirrot))
					binstance.direction = dirvar
					add_child(binstance)
					randomize()
					sfx_laser.pitch_scale = rand_range(0.9,1)
					sfx_laser.play()
					b_timer.start()
					green += -0.05
					blue += -0.05
		

#create a new enemy every second
func _on_simple_enemy_spawner_timeout():
	#randomize which enemy you're getting
	randomize()
	enemy_choice = floor(rand_range(0,level))
	
	#add the meteor enemy
	if enemy_choice == 0:
		var enemy_instance = simple_enemy.instance()
		enemy_instance.dir = floor(rand_range(1,5))
		enemy_instance.spd = asteroid_speed
		enemy_instance.rot_speed_dir = floor(rand_range(-2,3))
		add_child(enemy_instance)
	
	#add the ufo enemy
	if enemy_choice == 1:
		var UFO = UFO_enemy.instance()
		UFO.flipufoh = UFO.pos_array[floor(rand_range(0,3))]
		UFO.flipufov = UFO.pos_array[floor(rand_range(0,3))]
		UFO.UFO_speed = UFO_main_speed
		add_child(UFO)
	#add the red spaceship enemy
	if enemy_choice == 2:
		var red_ship = enemy_ship.instance()
		red_ship.dir = floor(rand_range(1,5))
		add_child(red_ship)
	
	enemy_timer = 1

		

#spawn new enemy type after X seconds 
func _on_level_timer_timeout():
	if level < 3:
		level += 1
		asteroid_speed = 100
		UFO_main_speed = 1
	

#delete ship for game over
func _on_Area2D_area_entered(_area):
	$Base/Area2D.queue_free()
	$Base/AnimationPlayer.play("explosion")
	$Base/explode_noise_base.play()
	game_loop = false

#speed up the asteroids over time
func _on_speed_up_timeout():
	asteroid_speed += 25 
	if level > 1:
		UFO_main_speed += 5

#handle the game over functions
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explosion":
		base.queue_free()
		$CanvasLayer/fade_rect/AnimationPlayer.playback_speed = 0.3
		$CanvasLayer/fade_rect/AnimationPlayer.play_backwards("fade")
		global_script_node.score_dict.current_score = score
	if anim_name == "fade" and game_loop == false:
		return get_tree().change_scene("res://scenes/game_over.tscn")
		

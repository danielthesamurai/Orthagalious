extends Node2D

var menu_state = 0
var config_file = File.new()
onready var global_script = get_node("/root/global_score")

func _ready():
	$CanvasLayer/fade_rect/AnimationPlayer.playback_speed = 3
	$CanvasLayer/fade_rect/AnimationPlayer.play("fade_in")
	$title_1/AnimationPlayer.play("flip_color")
	$title_2/AnimationPlayer.play("flip_color_2")
	if !config_file.file_exists("user://data.ini"):
		config_file.open("user://data.ini",File.WRITE)
		config_file.store_line(var2str(global_script.options.vsync))
		config_file.store_line(var2str(global_script.options.framecap))
		config_file.store_line(var2str(global_script.options.audio))
		config_file.store_line(var2str(global_script.options.real_audio))
		config_file.store_line(var2str(global_script.score_dict.high_score))
		config_file.close()
	else:
		config_file.open("user://data.ini",File.READ)
		global_script.options.vsync = str2var(config_file.get_line())
		global_script.options.framecap =str2var(config_file.get_line())
		global_script.options.audio = str2var(config_file.get_line())
		global_script.options.real_audio = str2var(config_file.get_line())
		global_script.score_dict.high_score = str2var(config_file.get_line())
		config_file.close()
	
func _process(_delta):
	if Input.is_action_just_pressed("x_key"):
		$CanvasLayer/fade_rect/AnimationPlayer.play("fade")
		menu_state = 1
	if Input.is_action_just_pressed("z_key"):
		$CanvasLayer/fade_rect/AnimationPlayer.play("fade")
		menu_state = 2
	if Input.is_action_just_pressed("c_key"):
		$CanvasLayer/fade_rect/AnimationPlayer.play("fade")
		menu_state = 3
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept"):
		OS.window_fullscreen = !OS.window_fullscreen
	#print(Engine.get_frames_per_second())
func _on_AnimationPlayer_animation_finished(anim_name):
	$title_1/AnimationPlayer.play("flip_color")
	$title_2/AnimationPlayer.play("flip_color_2")
	if anim_name == "fade" and menu_state == 1:
		return get_tree().change_scene("res://scenes/Main.tscn")
	if anim_name == "fade" and menu_state == 2:
		return get_tree().change_scene("res://scenes/options_menu.tscn")
	if anim_name == "fade" and menu_state == 3:
		return get_tree().change_scene("res://controls_screen.tscn")

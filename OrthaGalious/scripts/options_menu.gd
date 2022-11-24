extends Node2D

var track_state = 0
var track_menu_keys = 0
var frame_array = [30,60,120,144,"uncapped"]
var framecap_var = 1
var vsync_tracker = 1
var audio_var = 100
var real_audio_var = 0
var config_file = File.new()
onready var global_script = get_node("/root/global_score")

func _ready():
	framecap_var = global_script.options.framecap
	vsync_tracker = global_script.options.vsync
	audio_var = global_script.options.audio
	real_audio_var = global_script.options.real_audio
	
	$CanvasLayer/fade_rect/AnimationPlayer.play("fade")
	if vsync_tracker == 1:
		$vsync_label.text = "on"
		OS.vsync_enabled = true
	else:
		$vsync_label.text = "off"
		OS.vsync_enabled = false
		
func _process(_delta):
	if Input.is_action_just_released("ui_accept"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("z_key"):
		$CanvasLayer/fade_rect/AnimationPlayer.play_backwards("fade")
		config_file.open("user://data.ini",File.WRITE)
		config_file.store_line(var2str(global_script.options.vsync))
		config_file.store_line(var2str(global_script.options.framecap))
		config_file.store_line(var2str(global_script.options.audio))
		config_file.store_line(var2str(global_script.options.real_audio))
		config_file.close()
		track_state = 1
	if Input.is_action_just_pressed("ui_down"):
		track_menu_keys += 1
	if Input.is_action_just_pressed("ui_up"):
		track_menu_keys -= 1
	if track_menu_keys >= 3:
		track_menu_keys = 0
	if track_menu_keys <= -1:
		track_menu_keys = 2
	match_menu_keys()
	
	$frame_label.text = str(frame_array[framecap_var])


func _on_AnimationPlayer_animation_finished(_anim_name):
	if track_state == 1:
		return get_tree().change_scene("res://scenes/title_screen.tscn")
		
func FPS_select_input_handle():
	if Input.is_action_just_pressed("ui_right") and framecap_var < 4:
		framecap_var += 1
		global_script.options.framecap = framecap_var
	if Input.is_action_just_pressed("ui_left") and framecap_var > 0:
		framecap_var -= 1
		global_script.options.framecap = framecap_var
	match framecap_var:
		0:
			Engine.target_fps = 30
		1:
			Engine.target_fps = 60
		2:
			Engine.target_fps = 120
		3:
			Engine.target_fps = 144
		4:
			Engine.target_fps = 0

func vsync_input_handle():
	if vsync_tracker < 0:
			vsync_tracker = 1
	elif vsync_tracker > 1:
		vsync_tracker = 0
	if Input.is_action_just_pressed("ui_right"):
		vsync_tracker += 1
		global_script.options.vsync = vsync_tracker
	elif Input.is_action_just_pressed("ui_left"):
		vsync_tracker -= 1
		global_script.options.vsync = vsync_tracker
	if vsync_tracker == 1:
		$vsync_label.text = "on"
		OS.vsync_enabled = true
	elif vsync_tracker == 0:
		$vsync_label.text = "off"
		OS.vsync_enabled = false

func audio_input_handle():
	if Input.is_action_just_pressed("ui_left") and audio_var >= 10:
		audio_var -= 10
		real_audio_var -= 2
		global_script.options.audio = audio_var
		global_script.options.real_audio = real_audio_var
		$AudioStreamPlayer.play()
	if Input.is_action_just_pressed("ui_right") and audio_var <= 90:
		audio_var += 10
		real_audio_var += 2
		global_script.options.audio = audio_var
		global_script.options.real_audio = real_audio_var
		$AudioStreamPlayer.play()
	if audio_var <= 0:
		AudioServer.set_bus_mute(0,true)
	if audio_var > 0:
		AudioServer.set_bus_mute(0,false)
	AudioServer.set_bus_volume_db(0,real_audio_var)
	$volume_label.text = str(audio_var)

func match_menu_keys():
	match track_menu_keys:
		0:
			$volume_label.set("custom_colors/font_color",Color(1,0,0))
			$frame_label.set("custom_colors/font_color",Color(1,1,1))
			$vsync_label.set("custom_colors/font_color",Color(1,1,1))
			audio_input_handle()
		1:
			$volume_label.set("custom_colors/font_color",Color(1,1,1))
			$frame_label.set("custom_colors/font_color",Color(1,0,0))
			$vsync_label.set("custom_colors/font_color",Color(1,1,1))
			FPS_select_input_handle()
					
		2:
			$volume_label.set("custom_colors/font_color",Color(1,1,1))
			$frame_label.set("custom_colors/font_color",Color(1,1,1))
			$vsync_label.set("custom_colors/font_color",Color(1,0,0))
			vsync_input_handle()
				

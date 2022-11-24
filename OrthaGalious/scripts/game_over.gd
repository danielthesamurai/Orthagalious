extends Node2D
var config_file = File.new()
onready var global_script_vars = get_node("/root/global_score")

func _ready():
	if global_script_vars.score_dict.current_score > global_script_vars.score_dict.high_score:
		global_script_vars.score_dict.high_score = global_script_vars.score_dict.current_score
		$new_high_score.text = "*New High Score!*"
		config_file.open("user://data.ini",File.WRITE)
		config_file.store_line(var2str(global_script_vars.options.vsync))
		config_file.store_line(var2str(global_script_vars.options.framecap))
		config_file.store_line(var2str(global_script_vars.options.audio))
		config_file.store_line(var2str(global_script_vars.options.real_audio))
		config_file.store_line(var2str(global_script_vars.score_dict.high_score))
		config_file.close()
	else:
		$new_high_score.visible = false
	$High_Score.text = "Your Score: \n" + str(global_script_vars.score_dict.current_score)
	$score_tracker.text= "High Score: \n" + str(global_script_vars.score_dict.high_score)

func _process(_delta):
	if Input.is_action_just_pressed("x_key"):
		return get_tree().change_scene("res://scenes/Main.tscn")
	if Input.is_action_just_pressed("z_key"):
		return get_tree().change_scene("res://scenes/title_screen.tscn")
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_released("ui_accept"):
		OS.window_fullscreen = !OS.window_fullscreen
	

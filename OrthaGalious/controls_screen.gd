extends Node2D
var exit_state = 0

func _ready():
	$CanvasLayer/fade_rect/AnimationPlayer.play("fade")
	
func _process(_delta):
	if Input.is_action_just_pressed("c_key"):
		$CanvasLayer/fade_rect/AnimationPlayer.play_backwards("fade")
		exit_state = 1
	if Input.is_action_just_pressed("ui_accept"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_AnimationPlayer_animation_finished(_anim_name):
	if exit_state == 1:
		return get_tree().change_scene("res://scenes/title_screen.tscn")

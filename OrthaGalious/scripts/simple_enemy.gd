extends Sprite

#grab the necessary nodes and variables
onready var collider = get_node("Area2D")
onready var animplayer = get_node("AnimationPlayer")
onready var explodesound = get_node("AudioStreamPlayer")
var dir = 0
var spd = 1
var rot_speed_dir = 0

func _ready():
	#determine the starting position based on a random number determined in main script
	if dir == 1:
		position.x = 0
		position.y = 300
	if dir == 2:
		position.x = 800
		position.y = 300
	if dir == 3:
		position.x = 400
		position.y = 0
	if dir == 4:
		position.x = 400
		position.y = 600

func _process(delta):
	#determine the direction in which the asteroids travel based on the random number in main script
	if dir == 1:
		position.x += spd * delta
	if dir == 2: 
		position.x -= spd * delta
	if dir == 3:
		position.y += spd * delta
	if dir == 4:
		position.y -= spd * delta
	rotation_degrees += rot_speed_dir * delta 


func _on_Area2D_area_entered(area):
	#do all the "enemy death" stuff upon contact with bullet
	if area.is_in_group("bullet"):
		collider.queue_free()
		randomize()
		explodesound.pitch_scale = rand_range(0.8,1.1)
		spd = 0
		if !animplayer.is_playing():
			explodesound.play()
		animplayer.play("explode")


func _on_AnimationPlayer_animation_finished(anim_name):
	#remove the object once the explosion animation is finished
	if anim_name == "explode":
		queue_free()

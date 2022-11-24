extends Sprite
var timer = 0
var pos_vector = Vector2()
var circle_size = 300
var distance = 0
var rotation_speed = 100
var flipufoh = -1
var flipufov = -1
var move = true
var pos_array = [-1,-1,1,1]
var UFO_speed = 30

func _ready():
	distance = 350

func _process(delta):
	if move == true:
		timer += delta
		distance -= delta * UFO_speed
		position.x = (flipufoh * sin(timer*rotation_speed/distance)*distance + 400)
		position.y = (flipufov * cos(timer*rotation_speed/distance)*distance + 300)


func _on_Area2D_area_entered(area):
	if area.is_in_group("bullet"):
		$AnimationPlayer.play("death_spin")
		$AudioStreamPlayer.play()
		$Area2D.queue_free()
		move = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death_spin":
		queue_free()

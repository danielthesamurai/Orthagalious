extends Sprite

onready var default_sprite = load("res://sprites/enemy_ship_flying/ship_1.PNG")
onready var down_sprite = load("res://sprites/enemy_ship_flying/ship_2.PNG")
onready var up_sprite = load("res://sprites/enemy_ship_flying/ship_3.PNG")
onready var sfx = get_node("AudioStreamPlayer")
var y_spd = 350
var x_spd = 40
var spd_array = [-350,350]
var shot_at = false
var dir = 0

func _ready():
	if dir == 1:
		position.x = 300
		position.y = -20
	if dir == 2:
		position.x = 300
		position.y = 620
	if dir == 3:
		position.x = -20
		position.y = 400
	if dir == 4:
		position.x = 720
		position.y = 400
		
	
func _process(delta):
	if dir == 1:
		down_wave(delta)
	if dir == 2:
		up_wave(delta)
	if dir == 3:
		right_side_wave(delta)
	if dir == 4:
		left_side_wave(delta)
		
func left_side_wave(delta):
	position.x += -x_spd * delta
	scale.x = -0.5
	if shot_at == false:
		position.y = 300 + sin(position.x/20) * - 100
	else:
		position.y += y_spd * delta
	if position.y > 300:
		texture = up_sprite
	elif position.y < 250:
		texture = down_sprite
	else:
		texture = default_sprite

func right_side_wave(delta):
	position.x += x_spd * delta
	if shot_at == false:
		position.y = 300 + sin(position.x/20) * 100
	else:
		position.y -= y_spd * delta
	if position.y > 300:
		texture = up_sprite
	elif position.y < 250:
		texture = down_sprite
	else:
		texture = default_sprite

func down_wave(delta):
	position.y += x_spd * delta
	if shot_at == false:
		position.x = 400 + sin(position.y/20) * 100
		rotation_degrees = 90
	else:
		position.x -= y_spd * delta
	if position.y > 400:
		texture = up_sprite
	elif position.y < 200:
		texture = down_sprite
	else:
		texture = default_sprite
		
func up_wave(delta):
	position.y += -x_spd * delta
	if shot_at == false:
		position.x = 400 + sin(position.y/20) * 100
		rotation_degrees = -90
	else:
		position.x -= y_spd * delta
	if position.y > 400:
		texture = up_sprite
	elif position.y < 200:
		texture = down_sprite
	else:
		texture = default_sprite
	
	


func _on_Area2D_area_entered(area):
	if area.is_in_group("bullet"):
		texture = default_sprite
		randomize()
		rotation_degrees = rand_range(0,360)
		x_spd *= -1
		shot_at = true
		y_spd = spd_array[floor(rand_range(0,2))]
		sfx.pitch_scale = rand_range(0.8,1.2)
		sfx.play()
	


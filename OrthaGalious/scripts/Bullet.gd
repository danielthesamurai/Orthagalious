extends Sprite

var direction = "up"

func _process(delta):
	if direction == "up":
		move_up(delta)
	if direction == "down":
		move_down(delta)
	if direction == "left":
		move_left(delta)
	if direction == "right":
		move_right(delta)

func move_up(delta):
	position.y += -500 * delta
func move_down(delta):
	position.y += 500 * delta
func move_left(delta):
	position.x += -500 * delta
func move_right(delta):
	position.x += 500 * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(_area):
	queue_free()

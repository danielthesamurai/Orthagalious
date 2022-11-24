extends ParallaxBackground

#scroll the background vertically
func _process(delta):
	scroll_offset.y += 100 * delta

extends AnimatedSprite

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	# connects signal"animation_finished" to "self"'s function"_on_animation_finished".
	play("Animate")
	
func _on_animation_finished(): # connects signal to method
	queue_free()

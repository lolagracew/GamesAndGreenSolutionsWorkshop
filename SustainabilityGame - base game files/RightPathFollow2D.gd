extends PathFollow2D
var speed = 100

func _process(delta):
	set_offset(get_offset()+speed*delta)
	
	if(get_unit_offset() == 1):
		get_parent().queue_free()


func _on_BoatArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		self.get_node("RightBoat/BoatArea").queue_free()
		speed = 5000

extends KinematicBody2D

var movement = Vector2()
var state = 0
var timer = Timer.new()
var speed = 40

func _ready():
	# Here we are instancing a timer through code
	add_child(timer)
	timer.start(1)
	
	# We are creating the method that we can call when the timer times out
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout() -> void:
	# Generating a random value for state
	state = floor(rand_range(0,4))
	timer.start(1)

# Using our randomly generated state values, we are setting the position the trash will move
# in on the x and y axis'
func _physics_process(delta): 
	if state == 0:
		movement.y = 100
	elif state == 1:
		movement.x = 100
	elif state == 2:
		movement.x = -100
	elif state == 3:
		movement.y = -100
	else:
		movement.x = 100
	
	# we normalize the movement so that the trash is at the same speed in whatever direction it
	# travels
	movement = movement.normalized()
	movement = move_and_slide(movement * speed)
	# move and slide is a built in method, that allows us to tell our node that if it collides
	# (bumps into) another node, to simply slide around it

# This function allows us to delete the trash from the scene if the player clicks on it
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		self.queue_free()


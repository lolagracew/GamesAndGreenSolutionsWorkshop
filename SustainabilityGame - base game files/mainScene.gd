extends Node2D

var fishInScene = []
var location = Vector2()

onready var backgroundColour = get_node("CleanSeaBackground")
var cleanSeaBackGround = preload("res://gameAssets/cleanSeaBackground.png")
var dirtySeaBackground = preload("res://gameAssets/dirtySeaBackground.png")

# Built-in method, called 1 time only - when the scene is first run
func _ready():
	$LeftBoatInstanceDelay.start(rand_range(0,1))
	$OwnBoatInstanceDelay.start(rand_range(0,1))
	
# Built-in method, called every frame - so is constantly called when the game is running
func _process(delta):
	pass

func instanceLeftBoat():
	var LeftBoat = preload("res://LeftBoatOnPath.tscn").instance()
	add_child(LeftBoat)
	$LeftBoatInstanceDelay.start(rand_range(10,25))
	
func instanceOwnBoat():
	var ow = preload("res://BoatOnPath.tscn").instance()
	add_child(ow)
	$OwnBoatInstanceDelay.start(rand_range(10,25))

func instanceFish():
	randomize()
	
	# We store all our fish scenes we want to instance in an array, so that we can randomly
	# select which fish will be instanced next easily
	var packedFishScene = [
	preload("res://EelFishInstance.tscn"),
	preload("res://OrangeFishInstance.tscn"),
	preload("res://greenFishInstance.tscn")	
	]
	
	# by finding the viewport size we can make sure we instance our fish within this viewport,
	# as we don't want them off screen where the player can't interact with them
	var size = get_viewport().get_visible_rect().size
	location.x = rand_range(0,size.x)
	location.y = rand_range(0,size.y)
	
	# to randomly select a new fish to instance, we shuffle the fish array like a pack of cards
	packedFishScene.shuffle()
	var fish = packedFishScene[0].instance()
	fish.position = location
	
	# and finally add the fish as a child, which instances it in our scene. We add the new fish
	# to the fishInScene array so we can accurately keep track of what fish are in the scene
	add_child(fish)
	fishInScene.append(fish)
	
	
func instanceTrash():
	pass
	
## Timer functions
func _on_LeftBoatInstanceDelay_timeout():
	instanceLeftBoat()

func _on_OwnBoatInstanceDelay_timeout():
	instanceOwnBoat()
	
func _on_fishInstanceDelay_timeout():
	pass
	
func _on_TrashInstanceDelay_timeout():
	pass
	
# This method is used to remove any fish that instance outside of our fishing zone
# we do this to clean up our game for our players, we make the fish level easier
# to monitor by keeping fish in one area
func _on_Area2D_area_entered(area):
	if(area.name == "BoatArea"):
		if(len(fishInScene) > 2):
			var i = len(fishInScene)
			# if a fish instances outside of our fishing zone, we delete that fish from
			# the scene, and then we also delete it from the fish in scene array 
			fishInScene[i-1].queue_free()
			fishInScene.remove(i-1)

# This method is used to delete a fish from our scene if an illegal fisher enters the fishing
# zone
func _on_NoFishArea_area_entered(area):
	if(area.name == "BoatArea"):
		var i = fishInScene.find(area.get_parent())
		fishInScene.remove(i)
		area.get_parent().queue_free()	

extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x = self.rect_position.x 
	var y = self.rect_position.y
	var newPosition = Vector2(x, y + delta * 4)
	set_position(newPosition)
	print(1)
	pass

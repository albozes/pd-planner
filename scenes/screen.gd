extends Control

var sprite = preload("res://scenes/sprite.tscn")
var line = preload("res://scenes/line.tscn")

func loadSprite(file,pos : Vector2, id : int):
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	if texture:
		# Create a new Sprite2D node
		var newSprite = sprite.instantiate()
		newSprite.texture = texture
		newSprite.ID = id
		# Add the sprite to the scene
		$BGRect.add_child(newSprite)
		newSprite.add_to_group("layers")
		# Optionally, position the sprite at the drop location or a default location
		
		newSprite.position = pos

func moveLayer(id,x,y):
	for c in get_tree().get_nodes_in_group("layers"):
		print("Screen: searching for ID " + str(id))
		print(c.ID)
		if c.ID == id:
			print("Screen: moving " + str(id))
			c.position = Vector2(x,y)
			
func moveLine(id,startPoint,endPoint):
	for c in get_tree().get_nodes_in_group("lines"):
		print("Screen: searching for line ID " + str(id))
		print(c.ID)
		if c.ID == id:
			print("Screen: moving line " + str(id))
			c.set_points([startPoint, endPoint])

func deleteLayer(id):
	for c in get_tree().get_nodes_in_group("layers"):
		if c.ID == id:
			print("Screen: deleting " + str(id))
			c.queue_free()

func createLine(id : int, startPoint : Vector2, endPoint: Vector2):
	print("Attempting line creation")
	var newLine = line.instantiate()
	newLine.add_to_group("lines")
	newLine.set_points([startPoint, endPoint])
	newLine.width = 1
	newLine.default_color = Color("BLACK")
	newLine.ID = id
	add_child(newLine)
	move_child(newLine,get_child_count() - 2)

func deleteLine(id):
	for c in get_tree().get_nodes_in_group("lines"):
		if c.ID == id:
			print("Screen: deleting line " + str(id))
			c.queue_free()

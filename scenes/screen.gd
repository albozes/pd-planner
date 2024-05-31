extends Control

var sprite = preload("res://scenes/sprite.tscn")

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

func deleteLayer(id):
	for c in get_tree().get_nodes_in_group("layers"):
		if c.ID == id:
			print("Screen: deleting " + str(id))
			c.queue_free()

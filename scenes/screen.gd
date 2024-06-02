extends Control

var sprite = preload("res://scenes/sprite.tscn")
var line = preload("res://scenes/line.tscn")
var text = preload("res://scenes/text.tscn")

@onready var ThreeGrid = $ThreeGrid
@onready var FourGrid = $FourGrid
@onready var darkBG = $LightBG/DarkBG

func ready():
	grab_focus()

func loadSprite(file,pos : Vector2, id : int):
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	if texture:
		
		# Create a new Sprite2D node
		var newSprite = sprite.instantiate()
		newSprite.texture = texture
		newSprite.ID = id
		print("newSprite ID = " + str(newSprite.ID))
		
		# Add the sprite to the scene
		add_child(newSprite)
		move_child(newSprite,get_child_count() - 2)
		newSprite.add_to_group("sprites")
		newSprite.position = pos

func moveLayer(id,x,y):
	for c in get_tree().get_nodes_in_group("sprites") + get_tree().get_nodes_in_group("texts"):
		print("Screen: searching for ID " + str(id))
		print(c.ID)
		if c.ID == id:
			print("Screen: moving " + str(id))
			c.position = Vector2(x,y)
			
func createLine(id : int, startPoint : Vector2, endPoint: Vector2):
	print("Screen: attempting line creation")
	var newLine = line.instantiate()
	newLine.add_to_group("lines")
	newLine.set_points([startPoint, endPoint])
	newLine.width = 1
	newLine.default_color = Color("BLACK")
	newLine.ID = id
	add_child(newLine)
	move_child(newLine,get_child_count() - 2)

func moveLine(id,startPoint,endPoint):
	for c in get_tree().get_nodes_in_group("lines"):
		print("Screen: searching for line ID " + str(id))
		print(c.ID)
		if c.ID == id:
			print("Screen: moving line " + str(id))
			c.set_points([startPoint, endPoint])
			
func createText(id : int, pos : Vector2, input : String):
	print("Screen: attempting text creation")
	var newText = text.instantiate()
	add_child(newText)
	newText.add_to_group("texts")
	newText.set_Text(input)
	newText.set_Pos(pos)
	newText.ID = id
	move_child(newText,get_child_count() - 2)
	newText.enterTextEdit()

func delete(id):
	print("Screen: attempting deletion of " + str(id))
	for c in get_children():
		if c.get("ID") == id:
			print(c.ID)
			print("Screen: deleting " + str(id))
			c.queue_free()

func _on_bg_rect_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Clicked BG")
			hide()
			show()

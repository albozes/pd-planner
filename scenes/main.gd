extends Control

@onready var root = get_tree().get_root()
@onready var console = $HBoxContainer/CenterContainer/console
@onready var toolBox = $HBoxContainer/toolBox
@onready var frameToggle = $HBoxContainer/toolBox/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer/frameToggle
@onready var crosshairToggle = $HBoxContainer/toolBox/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer/crosshairToggle
@onready var darkBGToggle = $HBoxContainer/toolBox/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer2/darkBGButton
@onready var cursorPosLabel = $HBoxContainer/toolBox/MarginContainer/VBoxContainer/HBoxContainer/cursorPosLabel
@onready var lineWidthSlider = $HBoxContainer/toolBox/MarginContainer/VBoxContainer/HBoxContainer4/CrosshairWidth/lineWidthSlider

@onready var codeWindow = $CodeWindow
@onready var codeWindowText = $CodeWindow/TextEdit

@onready var layerContainer = $HBoxContainer/toolBox/MarginContainer/VBoxContainer/ScrollContainer/layerContainer

var layerScene = preload("res://scenes/layer.tscn")
var lineScene = preload("res://scenes/lineLayer.tscn")
var textScene = preload("res://scenes/textLayer.tscn")

var crosshairToggled : bool
var darkBGToggled : bool

var cursorPos : Vector2

var horizontalLine : Line2D
var verticalLine : Line2D
var lineWidth : float
var layerNumber : int = 0

func _ready():
	crosshairToggled = crosshairToggle.button_pressed
	darkBGToggled = darkBGToggle.button_pressed
	_on_dark_bg_button_toggled(darkBGToggled)
	for n in get_tree().get_nodes_in_group("demo"):
		n.queue_free()
	$FileDialog.hide()
	root.size_changed.connect(onResize)
	root.files_dropped.connect(filesDropped)
	_on_frame_toggle_toggled(frameToggle.button_pressed)
	createCrosshair(Vector2(24,24))
	_on_line_width_slider_value_changed(lineWidthSlider.value)
	onResize()
	
# createCrosshair: creates a crosshair made with 2x Line2Ds.
var crosshair : Control
var chOffset : int = 8

func createCrosshair(s: Vector2):
	crosshair = Control.new()
	add_child(crosshair)
	horizontalLine = Line2D.new()
	verticalLine = Line2D.new()
	
	var invertMaterial = load("res://invert.tres")
	# Ensure the viewport texture is set
	var viewport_texture = get_viewport().get_texture()
	invertMaterial.set("shader_param/viewport_texture", viewport_texture)
	
	#horizontalLine.material = invertMaterial
	horizontalLine.default_color = Color("black")
	verticalLine.default_color = Color("black")
	#verticalLine.material = invertMaterial

	# Define the color and width of the lines
	horizontalLine.width = lineWidth
	verticalLine.width = lineWidth

	# Horizontal line points
	horizontalLine.add_point(Vector2(0, s.y / 2))
	horizontalLine.add_point(Vector2(s.x, s.y / 2))

	# Vertical line points
	verticalLine.add_point(Vector2(s.x / 2, 0))
	verticalLine.add_point(Vector2(s.x / 2, s.y))

	# Add the lines to the scene
	crosshair.add_child(horizontalLine)
	crosshair.add_child(verticalLine)

# onResize: resizing the Window.

var realScreenPos : Vector2
var realScreenDim : Vector2

func onResize():
	toolBox.position.x = clamp(get_viewport().size.x - toolBox.size.x,564,6000)
	toolBox.size.y = get_viewport().size.y

	#Top Left Corner of the Playdate screen, minus the frame
	realScreenPos.x = console.position.x
	realScreenPos.y = console.position.y
	
	#Width
	realScreenDim.x = console.size.x * console.scale.x

	#Height
	realScreenDim.y = console.size.y * console.scale.y

#Toggling the yellow/black console frame.

func _on_frame_toggle_toggled(toggled_on):
	console.toggleFrame(toggled_on)

#filesDropped: handles both drag and drop, as well as file imports via the "add Sprites" button.

func filesDropped(files):
	# Loop through all dropped files
	print(files)
	for file in files:
		# Check if the file is an image
		if file.ends_with(".png") or file.ends_with(".jpg") or file.ends_with(".jpeg"):
			# Load the image as a texture
			layerNumber += 1
			print("Creating layer number " + str(layerNumber))
			var loadPos : Vector2
			if cursorPos.x < 390 and cursorPos.x > 10 and cursorPos.y > 10 and cursorPos.y < 230:
				loadPos = cursorPos
			else: loadPos = Vector2(200,120)
			console.loadSprite(file, loadPos,layerNumber)
			var newLayer = layerScene.instantiate()
			layerContainer.add_child(newLayer)
			layerContainer.move_child(newLayer,layerContainer.get_child_count()-1)
			newLayer.add_to_group("spriteLayers")
			newLayer.set_fileName(file.get_file())
			newLayer.setXPos(loadPos.x)
			newLayer.setYPos(loadPos.y)
			newLayer.set_ID(layerNumber)
			newLayer.posSet.connect(moveLayer)
			newLayer.export.connect(generateCode)
			newLayer.delete.connect(delete)
		else:
			print("Error. Not a valid PNG, JPG or JPEG.")
			
# General input handling

func _input(event):
	
	#Mouse movement: moves the cursor crosshair.
	
	if event is InputEventMouseMotion:
		onResize()
		#print("Mouse Position = " + str(get_viewport().get_mouse_position()))
		#print("realScreenPos = " + str(realScreenPos))
		crosshair.position = Vector2(get_viewport().get_mouse_position().x-chOffset*2+2,get_viewport().get_mouse_position().y-chOffset*2)
		cursorPos.x = remap(crosshair.position.x+chOffset+3,realScreenPos.x,realScreenPos.x+realScreenDim.x-1,0,400)
		cursorPos.y = remap(crosshair.position.y+chOffset+4,realScreenPos.y,realScreenPos.y+realScreenDim.y-1,0,240)
		cursorPosLabel.text = str(int(clamp(cursorPos.x,0,400))) + "," + str(int(clamp(cursorPos.y,0,240)))
		if cursorPos.x > -3 and cursorPos.x < 403 and cursorPos.y > -3 and cursorPos.y < 243:
				if crosshairToggled : crosshair.show()
				move_child(crosshair,get_child_count())
		else:
			crosshair.hide()
			pass

#Adjusts the crosshair width.

func _on_line_width_slider_value_changed(value):
	lineWidth = float(value)
	horizontalLine.width = lineWidth
	verticalLine.width = lineWidth

func moveLine(id : int, startPoint : Vector2,endPoint : Vector2):
	print("Main: attempting to move " + str(id))
	console.moveLine(id,startPoint,endPoint)
	
func moveLayer(id : int, x : int,y : int):
	console.moveLayer(id,x,y)

func delete(id : int):
	print("Main: attempting deletion of " + str(id))
	console.delete(id)

func createLine():
	layerNumber += 1
	console.createLine(layerNumber,Vector2(0,120),Vector2(400,120))
	var newLine = lineScene.instantiate()
	newLine.add_to_group("lineLayers")
	layerContainer.add_child(newLine)
	layerContainer.move_child(newLine,layerContainer.get_child_count()-1)
	newLine.set_ID(layerNumber)
	newLine.setStartPoint(Vector2(0,120))
	newLine.setEndPoint(Vector2(400,120))
	newLine.linePointSet.connect(moveLine)
	newLine.export.connect(generateCode)
	newLine.delete.connect(delete)

func _on_add_sprites_button_pressed():
	$FileDialog.show()

func createText():
	layerNumber += 1
	var startPos = Vector2(20,15)
	console.createText(layerNumber,startPos,"")
	var newText = textScene.instantiate()
	newText.add_to_group("textLayers")
	layerContainer.add_child(newText)
	layerContainer.move_child(newText,layerContainer.get_child_count()-1)
	newText.set_ID(layerNumber)
	newText.setPos(startPos)
	newText.posSet.connect(moveLayer)
	newText.export.connect(generateCode)
	newText.delete.connect(delete)

func _on_crosshair_toggle_toggled(toggled_on):
	crosshairToggled = toggled_on
	match toggled_on:
		true:
			crosshair.show()
		false:
			crosshair.hide()

func generateCode(elements):
	var code = ""
	for e in elements:
		if e.is_in_group("spriteLayers"):
			var pos
			for s in get_tree().get_nodes_in_group("sprites"):
				if s.get("ID") == e.ID:
					pos = s.position
			var fileName = e.fileName
			code += "local " + fileName.get_basename() + "Image = gfx.image.new(\"images/" + fileName + "\")"
			code += "\n" + fileName.get_basename() + "Sprite  = gfx.sprite.new(" + fileName.get_basename() + "Image)"
			code += "\n" + fileName.get_basename() + "Sprite:moveTo(" + str(pos.x) + "," + str(pos.y) + ")"
			print(code)
			code += "\n" + fileName.get_basename() + "Sprite:add()\n\n"
			
		if e.is_in_group("lineLayers"):
			code += "gfx.drawLine(" + str(e.startPoint.x) + "," + str(e.startPoint.y) + "," + str(e.endPoint.x) + "," + str(e.endPoint.y) + ")\n\n"
			
		if e.is_in_group("textLayers"):
			var text
			for t in get_tree().get_nodes_in_group("texts"):
				if t.get("ID") == e.ID:
					text = t.content
			text = text.replace("\\", "\\\\")
			text = text.replace("\n", "\\n")
			code += "gfx.drawText(\"" + text + "\"," + str(e.xPos) + "," + str(e.xPos) + ")\n\n"
	codeWindowText.text = code
	codeWindow.popup_centered()

func _on_code_window_close_requested():
	codeWindow.hide()

func _on_export_all_button_pressed():
	generateCode(layerContainer.get_children())


func _on_grid_selector_item_selected(index):
	console.showGrids(index)

func _on_dark_bg_button_toggled(toggled_on):
	darkBGToggled = toggled_on
	console.darkBG(toggled_on)

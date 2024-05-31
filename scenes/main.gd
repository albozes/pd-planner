extends Control

@onready var root = get_tree().get_root()
@onready var console = $console
@onready var toolBox = $toolBox
@onready var frameToggle = $toolBox/MarginContainer/VBoxContainer/frameToggle
@onready var cursorPosLabel = $toolBox/MarginContainer/VBoxContainer/HBoxContainer/cursorPosLabel
@onready var lineWidthSlider = $toolBox/MarginContainer/VBoxContainer/HBoxContainer2/lineWidthSlider

var layerScene = preload("res://scenes/layer.tscn")
var lineScene = preload("res://scenes/lineLayer.tscn")

var cursorPos : Vector2
var realScreenPos : Vector2
var realScreenDim : Vector2
var crosshair : Control
var horizontalLine : Line2D
var verticalLine : Line2D
var lineWidth : float
var layerNumber : int = 0

func _ready():
	$toolBox/MarginContainer/VBoxContainer/demoLayer.queue_free()
	$toolBox/MarginContainer/VBoxContainer/demoLine.queue_free()
	$FileDialog.hide()
	root.size_changed.connect(onResize)
	root.files_dropped.connect(filesDropped)
	_on_frame_toggle_toggled(frameToggle.button_pressed)
	createCrosshair(Vector2(25,25))
	_on_line_width_slider_value_changed(lineWidthSlider.value)
	onResize()

func onResize():
	toolBox.position.x = clamp(get_viewport().size.x - toolBox.size.x,930,10000)
	toolBox.size.y = get_viewport().size.y
	console.position.x = (get_viewport().size.x/3*2 - console.size.x*console.scale.x) /2
	console.position.y = (get_viewport().size.y - console.size.y*console.scale.y) /2
	
	#Top Left Corner
	realScreenPos.x = console.position.x + 20*console.scale.x
	realScreenPos.y = console.position.y + 20*console.scale.y
	
	#Width
	realScreenDim.x = (console.size.x - 40)*console.scale.x

	#Height
	realScreenDim.y = console.size.y*console.scale.y - 40*console.scale.y

func _on_frame_toggle_toggled(toggled_on):
	console.toggleFrame(toggled_on)

func filesDropped(files):
	# Loop through all dropped files
	print(files)
	for file in files:
		# Check if the file is an image
		if file.ends_with(".png") or file.ends_with(".jpg") or file.ends_with(".jpeg"):
			# Load the image as a texture
			layerNumber += 1
			var loadPos : Vector2
			if cursorPos.x < 390 and cursorPos.x > 10 and cursorPos.y > 10 and cursorPos.y < 230:
				loadPos = cursorPos
			else: loadPos = Vector2(200,120)
			console.loadSprite(file, loadPos,layerNumber)
			var newLayer = layerScene.instantiate()
			$toolBox/MarginContainer/VBoxContainer.add_child(newLayer)
			$toolBox/MarginContainer/VBoxContainer.move_child(newLayer,$toolBox/MarginContainer/VBoxContainer.get_child_count()-4)
			newLayer.set_fileName(file.get_file())
			newLayer.setXPos(loadPos.x)
			newLayer.setYPos(loadPos.y)
			newLayer.set_ID(layerNumber)
			newLayer.posSet.connect(moveLayer)
			newLayer.deleteLayer.connect(deleteLayer)
		else:
			print("Error. Not a valid PNG, JPG or JPEG.")

func _input(event):
	if event is InputEventMouseMotion:
		crosshair.position = Vector2(get_viewport().get_mouse_position().x-25,get_viewport().get_mouse_position().y-25)
		cursorPos.x = remap(crosshair.position.x+11,realScreenPos.x,realScreenPos.x+realScreenDim.x,0,400)
		cursorPos.y = remap(crosshair.position.y+11,realScreenPos.y,realScreenPos.y+realScreenDim.y,0,240)
		cursorPosLabel.text = str(int(clamp(cursorPos.x,0,400))) + "," + str(int(clamp(cursorPos.y,0,240)))
		if cursorPos.x > -1 and cursorPos.x < 401 and cursorPos.y > -1 and cursorPos.y < 241:
				crosshair.show()
				move_child(crosshair,get_child_count())
		else:
			crosshair.hide()
			pass

func createCrosshair(size: Vector2):
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
	horizontalLine.add_point(Vector2(0, size.y / 2))
	horizontalLine.add_point(Vector2(size.x, size.y / 2))

	# Vertical line points
	verticalLine.add_point(Vector2(size.x / 2, 0))
	verticalLine.add_point(Vector2(size.x / 2, size.y))

	# Add the lines to the scene
	crosshair.add_child(horizontalLine)
	crosshair.add_child(verticalLine)

func _on_line_width_slider_value_changed(value):
	lineWidth = float(value)
	horizontalLine.width = lineWidth
	verticalLine.width = lineWidth

func moveLine(id : int, startPoint : Vector2,endPoint : Vector2):
	print("Attempting moveLine")
	console.moveLine(id,startPoint,endPoint)
	
func moveLayer(id : int, x : int,y : int):
	console.moveLayer(id,x,y)

func deleteLayer(id : int):
	console.deleteLayer(id)
	
func deleteLine(id : int):
	console.deleteLine(id)

func createLine():
	layerNumber += 1
	console.createLine(layerNumber,Vector2(0,120),Vector2(400,120))
	var newLine = lineScene.instantiate()
	$toolBox/MarginContainer/VBoxContainer.add_child(newLine)
	$toolBox/MarginContainer/VBoxContainer.move_child(newLine,$toolBox/MarginContainer/VBoxContainer.get_child_count()-4)
	newLine.set_ID(layerNumber)
	newLine.setStartPoint(Vector2(0,120))
	newLine.setEndPoint(Vector2(400,120))
	newLine.linePointSet.connect(moveLine)
	newLine.deleteLine.connect(deleteLine)

func _on_add_sprites_button_pressed():
	$FileDialog.show()

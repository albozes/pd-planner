extends Control

@onready var root = get_tree().get_root()
@onready var console = $console
@onready var toolBox = $toolBox
@onready var frameToggle = $toolBox/MarginContainer/VBoxContainer/frameToggle
@onready var cursorPosLabel = $toolBox/MarginContainer/VBoxContainer/HBoxContainer/cursorPosLabel
@onready var lineWidthSlider = $toolBox/MarginContainer/VBoxContainer/HBoxContainer2/lineWidthSlider

var layerScene = preload("res://scenes/layer.tscn")

var cursorPos : Vector2
var realScreenPos : Vector2
var realScreenDim : Vector2
var crosshair : Control
var horizontalLine : Line2D
var verticalLine : Line2D
var lineWidth : float
var layerNumber : int = 0

func _ready():
	root.size_changed.connect(onResize)
	root.files_dropped.connect(filesDropped)
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
			console.loadSprite(file, cursorPos,layerNumber)
			var newLayer = layerScene.instantiate()
			$toolBox/MarginContainer/VBoxContainer.add_child(newLayer)
			newLayer.set_fileName(file.get_file())
			newLayer.setXPos(cursorPos.x)
			newLayer.setYPos(cursorPos.y)
			newLayer.set_ID(layerNumber)
			newLayer.xPosSet.connect(moveLayer)
			newLayer.yPosSet.connect(moveLayer)
			newLayer.closeLayer.connect(deleteLayer)
		else:
			print("Error. Not a valid PNG, JPG or JPEG.")

func _input(event):
	if event is InputEventMouseMotion:
		crosshair.position = Vector2(get_viewport().get_mouse_position().x-25,get_viewport().get_mouse_position().y-25)
		cursorPos.x = int(clamp(remap(crosshair.position.x+11,realScreenPos.x,realScreenPos.x+realScreenDim.x,0,400),0,400))
		cursorPos.y = int(clamp(remap(crosshair.position.y+11,realScreenPos.y,realScreenPos.y+realScreenDim.y,0,240),0,240))
		cursorPosLabel.text = str(cursorPos.x) + "," + str(cursorPos.y)
		if cursorPos.x > 0 and cursorPos.x < 400 and cursorPos.y > 0 and cursorPos.y < 240:
				crosshair.show()
				move_child(crosshair,get_child_count())
		else:
			crosshair.hide()
			pass

func createCrosshair(size: Vector2):
	crosshair = Control.new()
	add_child(crosshair)
	crosshair.z_index = 2
	horizontalLine = Line2D.new()
	verticalLine = Line2D.new()
	
	var invertMaterial = load("res://invert.tres")
	# Ensure the viewport texture is set
	var viewport_texture = get_viewport().get_texture()
	invertMaterial.set("shader_param/viewport_texture", viewport_texture)
	
	horizontalLine.material = invertMaterial
	verticalLine.material = invertMaterial

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

func moveLayer(id : int, x : int,y : int):
	console.moveLayer(id,x,y)

func deleteLayer(id : int):
	console.deleteLayer(id)

extends Control

@onready var fileNameLabel = $HBoxContainer/fileNameLabel
@onready var xPosEdit = $HBoxContainer/VBoxContainer/HBoxContainer/xPosEdit
@onready var xPosSlider = $HBoxContainer/VBoxContainer/HBoxContainer/CenterContainer/xPosSlider
@onready var yPosEdit = $HBoxContainer/VBoxContainer/HBoxContainer2/yPosEdit
@onready var yPosSlider = $HBoxContainer/VBoxContainer/HBoxContainer2/CenterContainer/yPosSlider

var ID : int
var fileName : String = ""
var xPos : int
var yPos : int

var sliderLength : int = 100

signal posSet
signal delete
signal export

func ready():
	var sliders = [xPosSlider,yPosSlider]
	for s in sliders:
		s.custom_minimum_size.x = sliderLength

func set_ID(id : int):
	ID = id
	set_fileName(fileNameLabel.text + " " + str(ID))

func set_fileName(n : String):
	fileName = n
	fileNameLabel.text = fileName
	
func setPos(input : Vector2):
	setXPos(input.x)
	setYPos(input.y)

func setXPos(input):
	#Check validity
	var number : int
	if input is String:
		input = input.strip_edges()
		# Check if the text is empty
		if !input.is_empty():
			number = input.to_int()
	
	# Check if the conversion was successful and if the text represents a valid number
		if str(number) == input or str(int(number)) == input:
			pass
		else:
			number = xPos
	else:
		number = input
	xPos = number
	xPosEdit.text = str(number)
	xPosSlider.value = number
	posSet.emit(ID,xPos,yPos)

func setYPos(input):
	#Check validity
	var number : int
	if input is String:
		input = input.strip_edges()
		
		# Check if the text is empty
		if !input.is_empty():
			number = input.to_int()
		# Check if the conversion was successful and if the text represents a valid number
		if str(number) == input or str(int(number)) == input:
			pass
		else:
			number = yPos
	else:
		number = input
	yPos = number
	yPosEdit.text = str(number)
	yPosSlider.value = number
	posSet.emit(ID,xPos,yPos)

func _on_x_button_pressed():
	delete.emit(ID)
	self.queue_free()

func _on_export_button_pressed():
	export.emit(self)

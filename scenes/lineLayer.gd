extends Control

@onready var fileNameLabel = $HBoxContainer/fileNameLabel
@onready var startPointXEdit = $HBoxContainer/startPointContainer/HBoxContainer/startPointXEdit
@onready var startPointYEdit = $HBoxContainer/startPointContainer/HBoxContainer2/startPointYEdit
@onready var startPointXSlider = $HBoxContainer/startPointContainer/HBoxContainer/CenterContainer/startPointXSlider
@onready var startPointYSlider = $HBoxContainer/startPointContainer/HBoxContainer2/CenterContainer/startPointYSlider
@onready var endPointXEdit = $HBoxContainer/endPointContainer/HBoxContainer/endPointXEdit
@onready var endPointYEdit = $HBoxContainer/endPointContainer/HBoxContainer2/endPointYEdit
@onready var endPointXSlider = $HBoxContainer/endPointContainer/HBoxContainer/CenterContainer/endPointXSlider
@onready var endPointYSlider = $HBoxContainer/endPointContainer/HBoxContainer2/CenterContainer/endPointYSlider

var ID : int
var fileName : String = ""
var startPoint : Vector2
var endPoint : Vector2

signal linePointSet
signal deleteLine

func set_ID(id : int):
	ID = id
	fileNameLabel.text += " " + str(ID)

func set_fileName(name : String):
	fileName = name
	fileNameLabel.text = fileName

func setStartPointX(xInput):
	var x = int(xInput)
	setStartPoint(Vector2(x,startPoint.y))
	startPoint = Vector2(x,startPoint.y)
	
func setStartPointY(yInput):
	var y = int(yInput)
	setStartPoint(Vector2(startPoint.x,y))
	startPoint = Vector2(startPoint.x,y)

func setStartPoint(input : Vector2):
	startPoint = input
	startPointXEdit.text = str(input.x)
	startPointXSlider.value = input.x
	startPointYEdit.text = str(input.y)
	startPointYSlider.value = input.y
	linePointSet.emit(ID,startPoint,endPoint)
	
func setEndPointX(xInput):
	var x = int(xInput)
	setEndPoint(Vector2(x,endPoint.y))
	endPoint = Vector2(x,endPoint.y)
	
func setEndPointY(yInput):
	var y = int(yInput)
	setEndPoint(Vector2(endPoint.x,y))
	endPoint = Vector2(endPoint.x,y)

func setEndPoint(input : Vector2):
	endPoint = input
	endPointXEdit.text = str(input.x)
	endPointXSlider.value = input.x
	endPointYEdit.text = str(input.y)
	endPointYSlider.value = input.y
	linePointSet.emit(ID,startPoint,endPoint)

func _on_x_button_pressed():
	deleteLine.emit(ID)
	self.queue_free()

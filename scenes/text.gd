extends Control

@onready var edit = $TextEdit

var ID : int
var content : String

func set_Text(input : String):
	content = input
	edit.text = content

func set_Pos(pos : Vector2):
	position = pos
	
func enterTextEdit():
	edit.grab_focus()

func _on_text_edit_focus_entered():
	edit.add_theme_color_override("background_color",Color("black"))
	edit.add_theme_color_override("font_color",Color("white"))

func _on_text_edit_text_set():
	edit.add_theme_color_override("background_color",Color(0))
	edit.add_theme_color_override("font_color",Color("black"))
	content = edit.text

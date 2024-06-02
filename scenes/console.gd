extends Control

func toggleFrame(s : bool):
	match s:
		true:
			$yellowFrame.show()
			$blackFrame.show()
		false:
			$yellowFrame.hide()
			$blackFrame.hide()

func loadSprite(file, pos : Vector2, id : int):
	print("Console loading sprite, layer " + str(id))
	$screen.loadSprite(file, pos, id)
	
func createLine(id: int,startPoint : Vector2, endPoint : Vector2):
	$screen.createLine(id,startPoint,endPoint)
	
func createText(id: int, pos : Vector2, input : String):
	$screen.createText(id,pos,input)
	
func moveLine(id,x,y):
	print("Console: moving " + str(id))
	$screen.moveLine(id,x,y)

func moveLayer(id,x,y):
	print("Console: moving " + str(id))
	$screen.moveLayer(id,x,y)

func delete(id):
	print("Console: attempting deletion of " + str(id))
	$screen.delete(id)

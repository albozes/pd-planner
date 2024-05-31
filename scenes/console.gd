extends Control

func toggleFrame(show : bool):
	match show:
		true:
			$yellowFrame.show()
			$blackFrame.show()
		false:
			$yellowFrame.hide()
			$blackFrame.hide()

func loadSprite(file, pos : Vector2, id : int):
	$screen.loadSprite(file, pos, id)
	
func createLine(id: int,startPoint : Vector2, endPoint : Vector2):
	$screen.createLine(id,startPoint,endPoint)
	
func moveLine(id,x,y):
	print("Console: Moving Line " + str(id))
	$screen.moveLine(id,x,y)

func moveLayer(id,x,y):
	print("Console: Moving " + str(id))
	$screen.moveLayer(id,x,y)

func deleteLayer(id):
	$screen.deleteLayer(id)

func deleteLine(id):
	$screen.deleteLine(id)

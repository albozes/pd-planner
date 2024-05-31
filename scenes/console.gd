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

func moveLayer(id,x,y):
	print("Console: Moving " + str(id))
	$screen.moveLayer(id,x,y)

func deleteLayer(id):
	$screen.deleteLayer(id)

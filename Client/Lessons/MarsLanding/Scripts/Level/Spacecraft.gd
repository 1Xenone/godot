extends Node2D

var ship
var lvl

enum GameState {Running, Crashed, Landed}

func _process(delta):
	match ship.state:
		ship.GameState.Running:
			pass
		ship.GameState.Crashed:
			get_node("body").visible = false
			get_node("fire").visible = false
			get_node("crash").visible = true
			ClosingUpdate(delta)
			return
		ship.GameState.Landed:
			get_node("fire").visible = false
			ClosingUpdate(delta)
			return
	
	if(ship.thrust == 0):
		get_node("fire").visible = false
	else:
		get_node("fire").visible = true
	
	match ship.thrust:
		1:
			get_node("fire").play("Speed1")
		2:
			get_node("fire").play("Speed2")
		3:
			get_node("fire").play("Speed3")
		4:
			get_node("fire").play("Speed4")

var closingTime = 0
func ClosingUpdate(delta):
	closingTime += delta
	if(lvl.timeBeforeClosing < closingTime):
		get_tree().quit()



func _on_SpacecraftController_Init(_ship, _lvl):
	ship = _ship
	lvl = _lvl

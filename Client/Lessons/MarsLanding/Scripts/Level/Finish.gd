extends Area2D

var ship
var lvl


func _on_Finish_area_shape_entered(area_id, area, area_shape, local_shape):
	if(ship.vSpeed >= lvl.landingSpeed):
		ship.state = ship.GameState.Crashed
	else:
		ship.state = ship.GameState.Landed



func _on_SpacecraftController_Init(_ship, _lvl):
	ship = _ship
	lvl = _lvl

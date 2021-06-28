extends Node

var ship

var fuelText = "FUEL                    "
var vspeedText = "VERTICAL SPEED  "
var vdistanceText = "DISTANCE          "

func _process(delta):
	get_node("Fuel").text = fuelText + String(int(ship.Fuel))
	get_node("VSpeed").text = vspeedText + String(int(ship.vSpeed))
	get_node("VDistance").text = vdistanceText + String(int(ship.vDistance))


func _on_SpacecraftController_Init(_ship, _lvl):
	ship = _ship

class_name GameStates

var lvl : Resource
var ship : Resource
var shipPhysics


func _init(_lvl, _ship, _shipPhysics):
	lvl = _lvl
	ship = _ship
	shipPhysics = _shipPhysics

func Update(delta):
	if(ship.state == ship.GameState.Running):
		shipPhysics.Update(delta)
		lvl.shipPosition = Vector2(lvl.shipPosition.x, lvl.landingPad[0].y - ship.vDistance)
		
		if(HasShipLanded()):
			ship.state = ship.GameState.Landed
		elif(HasShipCrashed()):
			ship.state = ship.GameState.Crashed


func HasShipLanded() -> bool:
	return ship.vDistance <= 0 && ship.vSpeed <= lvl.landingSpeed

func HasShipCrashed() -> bool:
	return ship.vDistance <= 0 && ship.vSpeed > lvl.landingSpeed

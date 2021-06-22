class_name ShipPhysics

var userScriptPath = "res://Lessons/MarsLanding/Scripts/Learner/UserScript.cs"
var csharp_script = load(userScriptPath)
var csharp_node = csharp_script.new()

var timefromPreviousUpdate

var lvl
var ship

func _init(_lvl, _ship):
	lvl = _lvl
	ship = _ship
	
	timefromPreviousUpdate = lvl.frameDuration
	ship.vDistance = lvl.landingPad[0].y - lvl.shipPosition.y

func Update(delta): 
	while(timefromPreviousUpdate >= lvl.frameDuration
	  && ship.state == ship.GameState.Running):
		timefromPreviousUpdate -= lvl.frameDuration
		_updateShipFrame(delta)
	
	timefromPreviousUpdate += delta

func _updateShipFrame(delta):
	if(ship.Fuel > 0):
		ship.thrust = csharp_node.Update(ship.vSpeed, ship.vDistance)
		ship.Fuel -= ship.thrust * delta
		if(ship.Fuel <= 0):
			ship.Fuel = 0
			ship.thrust = 0
	
	_oneFrameSimulation(ship.thrust, delta / lvl.frameDuration)

func _oneFrameSimulation(thrust, delta):
	ship.vSpeed += (lvl.mars_gravity - thrust) * delta
	ship.vDistance -= ship.vSpeed * delta	

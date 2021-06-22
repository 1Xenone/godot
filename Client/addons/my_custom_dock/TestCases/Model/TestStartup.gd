class_name TestStartup

var lvl : Resource
var ship : Resource
var shipPhysics : ShipPhysics
var gameStates : GameStates

export(bool) var hasEnded = false
export(bool) var hasSucceded = false

export(int) var framesPerLog = 15

var frameDutartion
var previousUpdateTime
func _init(_lvl, _ship):
	lvl = _lvl.duplicate()
	ship = _ship.duplicate()
	shipPhysics = ShipPhysics.new(lvl, ship)
	gameStates = GameStates.new(lvl, ship, shipPhysics)
	frameDutartion = _lvl.frameDuration * framesPerLog
	previousUpdateTime = frameDutartion
	hasEnded = false


func Update(delta):
	if(hasEnded):
		return
	delta = 0.1
	gameStates.Update(delta)
	if(frameDutartion <= previousUpdateTime):
		Log()
		previousUpdateTime -= frameDutartion
	previousUpdateTime += delta
	
	match(ship.state):
		ship.GameState.Landed:
			Log()
			print("Successfuly landed with fuel " + String(ship.Fuel))
			hasEnded = true
			hasSucceded = true
		ship.GameState.Crashed:
			Log()
			print("Crashed")
			hasEnded = true
			hasSucceded = false


func Log():
	print("Speed: " + String(ship.vSpeed))
	print("Distance: " + String(ship.vDistance))
	print("Fuel: " + String(ship.Fuel))
	print("Thrust: " + String(ship.thrust))

extends Resource
class_name TestStartup

export(Resource) var lvl 
export(Resource) var ship
var shipPhysics : ShipPhysics
var gameStates : GameStates

var hasEnded = false

var framesPerLog = 15
var speedX = 8
var fixedUpdate = 0.05

var logInterval
var previousLogTime
func _init(_lvl, _ship):
	lvl = _lvl
	ship = _ship
	shipPhysics = ShipPhysics.new(lvl, ship)
	gameStates = GameStates.new(lvl, ship, shipPhysics)
	logInterval = _lvl.frameDuration * framesPerLog
	previousLogTime = logInterval
	hasEnded = false

var previousUpdateTime = 0
func Update(delta):
	if(hasEnded):
		return
	delta = delta * speedX
	
	previousUpdateTime += delta
	while(previousUpdateTime > fixedUpdate):
		previousUpdateTime -= fixedUpdate
		gameStates.Update(fixedUpdate)
	
	if(logInterval <= previousLogTime):
		Log()
		previousLogTime -= logInterval
	previousLogTime += delta
	
	match(ship.state):
		ship.GameState.Landed:
			Log()
			print("Successfuly landed with fuel " + String(ship.Fuel))
			hasEnded = true
		ship.GameState.Crashed:
			Log()
			print("Crashed")
			hasEnded = true


func Log():
	print("Speed: " + String(ship.vSpeed))
	print("Distance: " + String(ship.vDistance))
	print("Fuel: " + String(ship.Fuel))
	print("Thrust: " + String(ship.thrust))

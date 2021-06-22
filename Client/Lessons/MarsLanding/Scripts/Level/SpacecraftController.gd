extends Node

export(Resource) var ship
export(Resource) var lvl


var userScriptPath = "res://Lessons/MarsLanding/Scripts/Learner/UserScript.cs"
var csharp_script = load(userScriptPath)
var csharp_node = csharp_script.new()


func OneSecondSimulation(thrust, delta):
	ship.vSpeed += (lvl.mars_gravity - thrust) * delta
	ship.vDistance -= ship.vSpeed * delta

var shipNode
var finishNode

func _ready():
	shipNode = get_parent().get_node("Spacecraft")
	finishNode = get_parent().get_node("Finish")
	
	ship.vSpeed = lvl.initialSpeed
	ship.Fuel = lvl.initialFuel
	ship.vDistance = finishNode.position.y - shipNode.position.y

onready var timefromPreviousUpdate = lvl.frameDuration
func _process(delta):
	if(ship.state != ship.GameState.Running):
		return
	
	while(timefromPreviousUpdate >= lvl.frameDuration
	  && ship.state == ship.GameState.Running):
		timefromPreviousUpdate -= lvl.frameDuration
		if(ship.Fuel > 0):
			ship.thrust = csharp_node.Update(ship.vSpeed, ship.vDistance)
			ship.Fuel -= ship.thrust
			if(ship.Fuel < 0):
				ship.Fuel = 0
		else:
			ship.thrust = 0
	
	timefromPreviousUpdate += delta
	OneSecondSimulation(ship.thrust, delta / lvl.frameDuration)
	shipNode.position.y = finishNode.position.y - ship.vDistance 


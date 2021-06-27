class_name SpaceController extends Node

export(Resource) var gameInjection

var shipNode
var finishNode

var startup

func _enter_tree():
	GV.ship = gameInjection.ship
	GV.lvl = gameInjection.lvl
	startup = TestStartup.new(GV.lvl, GV.ship)
	gameInjection = preload("res://addons/my_custom_dock/TestCases/gameInjection.tres")
	gameInjection.hasEnded = false
	gameInjection.hasSucceeded = false
	err(ResourceSaver.save("res://addons/my_custom_dock/TestCases/gameInjection.tres", gameInjection))

func _ready():
	shipNode = get_parent().get_node("Spacecraft")
	finishNode = get_parent().get_node("Finish")

func _process(delta):
	if(gameInjection.hasEnded):
		return
	
	match(GV.ship.state):
		GV.ship.GameState.Landed:
			gameInjection = preload("res://addons/my_custom_dock/TestCases/gameInjection.tres")
			gameInjection.hasEnded = true
			gameInjection.hasSucceeded = true
			err(ResourceSaver.save("res://addons/my_custom_dock/TestCases/gameInjection.tres", gameInjection))
		GV.ship.GameState.Crashed:
			gameInjection = preload("res://addons/my_custom_dock/TestCases/gameInjection.tres")
			gameInjection.hasEnded = true
			gameInjection.hasSucceeded = false
			err(ResourceSaver.save("res://addons/my_custom_dock/TestCases/gameInjection.tres", gameInjection))
	
	if(GV.ship.state != GV.ship.GameState.Running):
		return
	
	startup.Update(delta)
	shipNode.position.y = finishNode.position.y - GV.ship.vDistance 

class_name SpaceController extends Node

export(Resource) var gameInjection

signal Init(ship, lvl)

var shipNode
var finishNode

var startup

var ship
var lvl

func _enter_tree():
	ship = gameInjection.ship
	lvl = gameInjection.lvl
	emit_signal("Init", ship, lvl)
	startup = TestStartup.new(lvl, ship)
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
	
	match(ship.state):
		ship.GameState.Landed:
			gameInjection = preload("res://addons/my_custom_dock/TestCases/gameInjection.tres")
			gameInjection.hasEnded = true
			gameInjection.hasSucceeded = true
			err(ResourceSaver.save("res://addons/my_custom_dock/TestCases/gameInjection.tres", gameInjection))
		ship.GameState.Crashed:
			gameInjection = preload("res://addons/my_custom_dock/TestCases/gameInjection.tres")
			gameInjection.hasEnded = true
			gameInjection.hasSucceeded = false
			err(ResourceSaver.save("res://addons/my_custom_dock/TestCases/gameInjection.tres", gameInjection))
	
	if(ship.state != ship.GameState.Running):
		return
	
	startup.Update(delta)
	shipNode.position.y = finishNode.position.y - ship.vDistance 

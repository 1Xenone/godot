tool
extends ColorRect

export(Resource) var testCase
export(int) var number

export(int) var hasSucceeded

var startup

var gameInjection

var ship
var lvl

# Called when the node enters the scene tree for the first time.
func _ready():
	ship = testCase.ship.duplicate()
	lvl = testCase.lvl.duplicate()
	
	get_node("HBox/Description").text = testCase.name
	if(number < 10):
		get_node("HBox/Number").text = "0" + String(number)
	else:
		get_node("HBox/Number").text = String(number)


func _process(delta):
	if(!gameInjection):
		return;
	if(gameInjection.hasEnded):
		get_node("Success").visible = gameInjection.hasSucceeded
		get_node("Fail").visible = !gameInjection.hasSucceeded
		hasSucceeded = gameInjection.hasSucceeded


func _on_PlayTest_pressed():
	ship = testCase.ship.duplicate()
	lvl = testCase.lvl.duplicate()
	
	gameInjection = preload("res://addons/my_custom_dock/TestCases/gameInjection.tres")
	gameInjection.lvl = lvl
	gameInjection.ship = ship
	gameInjection.hasEnded = false
	err(ResourceSaver.save("res://addons/my_custom_dock/TestCases/gameInjection.tres", gameInjection))
	run_scene()


var useLogs = false

func _on_See_log_pressed():
	useLogs = true

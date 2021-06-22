tool
extends ColorRect

export(Resource) var testCase
export(int) var number

var startup

var isTestPlaying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("HBox/Description").text = testCase.name
	if(number < 10):
		get_node("HBox/Number").text = "0" + String(number)
	else:
		get_node("HBox/Number").text = String(number)


func _process(delta):
	if(isTestPlaying):
		startup.Update(delta)
		if(startup.hasEnded):
			isTestPlaying = false
			get_node("Success").visible = startup.hasSucceded
			get_node("Fail").visible = !startup.hasSucceded
	
	if(waitForGameStart):
		#print("waiting")
		if(get_tree().get_root().find_node("Lvl3", true, false)):
			print("tree")


func _on_PlayTest_pressed():
	startup = TestStartup.new(testCase.lvl, testCase.ship)
	isTestPlaying = true


var waitForGameStart = false

func _on_See_log_pressed():
	#_on_PlayTest_pressed()
	run_current_scene()
	waitForGameStart = true
	# set parameters to path in global resources
	pass # Replace with function body.

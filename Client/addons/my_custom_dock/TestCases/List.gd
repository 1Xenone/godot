tool
extends VBoxContainer

export(PackedScene) var testCaseScene
export(Array, Resource) var tests
export(PackedScene) var submitBtn

var node
var submitBtnNode
func _ready():
	var testNumber = 1
	for test in tests:
		node = testCaseScene.instance()
		node.testCase = test
		node.number = testNumber
		testNumber = testNumber + 1
		add_child(node, true)
	submitBtnNode = submitBtn.instance()
	add_child(submitBtnNode, true)
	

func _process(delta):
	if(node && node.hasSucceeded):
		submitBtnNode.completedTests = 2

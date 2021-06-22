tool
extends VBoxContainer

export(PackedScene) var testCaseScene
export(Array, Resource) var tests


func _ready():
	var testNumber = 1
	for test in tests:
		var node = testCaseScene.instance()
		node.testCase = test
		node.number = testNumber
		testNumber = testNumber + 1
		add_child(node, true)

func _process(delta):
	pass

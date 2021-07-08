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
		print(node)

		node.testCase = test
		node.number = testNumber
		testNumber = testNumber + 1
		add_child(node, true)
	submitBtnNode = submitBtn.instance()
	add_child(submitBtnNode, true)
	

func _process(delta):
	var count = self.get_child_count() - 1;
	var index = 0
	var completedCount = 0
	for test in self.get_children():
		if(count != index):
			if(test.hasSucceeded):
				completedCount = completedCount + 1
		else:
			test.completedTests = completedCount
		index = index + 1
	

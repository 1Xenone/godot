tool
extends HBoxContainer

export(int) var completedTests = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("VBoxContainer/BtnBox/HBox/Number").text = String(completedTests) + "/2"


func _on_Submit_pressed():
	if(completedTests == 2):
		get_node("VBoxContainer/BtnBox/Success").visible = true
		get_node("VBoxContainer/BtnBox/Fail").visible = false
	else:
		get_node("VBoxContainer/BtnBox/Success").visible = false
		get_node("VBoxContainer/BtnBox/Fail").visible = true

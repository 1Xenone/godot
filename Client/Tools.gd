tool
extends Node

signal restart_tools()


export var restart_tools = false setget do_restart_tools


func do_restart_tools(_p_estart_tools = null):
	emit_signal("restart_tools")

func _on_ToolsButton_pressed():
	do_restart_tools()

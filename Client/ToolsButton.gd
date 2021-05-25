tool
extends Node

signal restart_tools()


export var restart_tools = false setget do_restart_tools


func do_restart_tools(_p_estart_tools = null):
	emit_signal("restart_tools")

func _on_ToolsButton_pressed():
	#packFile(lessonName)
	do_restart_tools()

var lessonName = "Lvl3"
var dir = Directory.new()
var file = File.new()
func packFile(lessonName):
	var p := ZIPPacker.new()
	var archivePath = GV.lessonsServerFolder + lessonName + GV.archiveType
	err(p.open(GV.lessonsServerFolder + lessonName + GV.archiveType))
	err(dir.open(GV.lessonsServerFolder + lessonName))
	err(dir.list_dir_begin(true, true))
	var fileName = dir.get_next()
	while(fileName != ""):
		if(dir.file_exists(archivePath)):
			err(p.open(GV.lessonsServerFolder + lessonName + GV.archiveType, ZIPPacker.APPEND_ADDINZIP))
		else:
			err(p.open(GV.lessonsServerFolder + lessonName + GV.archiveType))
		p.start_file(fileName)
		err(file.open(GV.lessonsServerFolder + lessonName + "/" + fileName, File.READ))
		var lenth = file.get_len()
		var fileContent = file.get_buffer(file.get_len())
		p.write_file(fileContent)
		
		file.close()
		p.close()
		
		fileName = dir.get_next()

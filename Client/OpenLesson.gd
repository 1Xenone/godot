#tool
extends Node
signal download_lesson(lessonName)


var file = File.new()
var dir = Directory.new()

func _on_GetLessonID_open_lesson(lessonName):
	var scenePath = GV.lessonsClientFolder + lessonName + "/" + lessonName + GV.sceneType
	if(file.file_exists(scenePath)):
		get_tree().change_scene(scenePath)
	else:
		emit_signal("download_lesson", lessonName)


func openArchive(lessonName):
	var archivePath = GV.lessonsClientFolder + lessonName + GV.archiveType
	var r := ZIPReader.new()
	r.open(archivePath)
	
	for filename in r.get_files():
		var dirrectoryPath = GV.lessonsClientFolder + lessonName
		var filePath = dirrectoryPath + "/" + filename
		if(!dir.dir_exists(dirrectoryPath)):
			dir.make_dir(dirrectoryPath)
		
		dir.open(filePath)
		err(file.open(filePath, File.WRITE))
		var file_content = r.read_file(filename)
		file.store_buffer(file_content)
		file.close()
	
	_on_GetLessonID_open_lesson(lessonName)


func _on_DownloadLesson_lesson_downloaded(lessonName):
	openArchive(lessonName)
	pass # Replace with function body.


func _on_ToolsButton_restart_tools():
	pass


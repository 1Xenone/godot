#tool
extends Node
signal lesson_downloaded(lessonName)


var client = StreamPeerTCP.new()
var wrapped_client

var requestedLessonName

var is_ready = false

func start():
	is_ready = true


func _process(_delta):
	if(is_ready && wrapped_client):
		poll_server()


var file = File.new()
func poll_server():	
	while wrapped_client.get_available_packet_count() > 0:
		# check for existing file with file.file_exists
		if(!file.is_open()):
			var msg = wrapped_client.get_var()
			err(wrapped_client.get_packet_error())
			
			file.open(GV.lessonsClientFolder + msg, File.WRITE)
		else:
			var data = wrapped_client.get_packet()
			print("Client: Get file data")
			err(wrapped_client.get_packet_error())
			
			file.store_buffer(data)
			file.close()
			
			emit_signal("lesson_downloaded", requestedLessonName)


func _on_OpenLesson_download_lesson(lessonName):
	requestedLessonName = lessonName
	
	err(client.connect_to_host(GV.address, GV.port))
	
	if client.is_connected_to_host():
		wrapped_client = PacketPeerStream.new()
		wrapped_client.set_stream_peer(client)
		
		client.put_string(requestedLessonName)
	
	err(wrapped_client.get_packet_error())


func _on_ToolsButton_restart_tools():
	start()


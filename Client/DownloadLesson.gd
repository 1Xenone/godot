#tool
extends Node
signal lesson_downloaded(lessonName)

var port = 1236
var ip = "127.0.0.1"

var lessonsFolder = "res://ClientFolder/"

var client
var wrapped_client
var is_ready = false

var internalLessonName

func start():
	client = StreamPeerTCP.new()
	file = File.new()
	
	var error = client.connect_to_host(ip, port)
	if error != 0:
		push_error("Error on connecting to host: %s" % error)
	
	if client.is_connected_to_host():
		wrapped_client = PacketPeerStream.new()
		wrapped_client.set_stream_peer(client)
	
	is_ready = true


func _process(_delta):
	if(is_ready && wrapped_client):
		poll_server()


var file
func poll_server():	
	while wrapped_client.get_available_packet_count() > 0:
		# check for existing file with file.file_exists
		if(!file.is_open()):
			var msg = wrapped_client.get_var()
			var error = wrapped_client.get_packet_error()
			if error != 0:
				push_error("Error on packet get: %s" % error)
			
			file.open(lessonsFolder + msg, File.WRITE)
		else:
			var data = wrapped_client.get_packet()
			print("Client: Get file data")
			var error = wrapped_client.get_packet_error()
			if error != 0:
				push_error("Error on packet get: %s" % error)
			
			file.store_buffer(data)
			file.close()
			
			emit_signal("lesson_downloaded", internalLessonName)


func _on_OpenLesson_download_lesson(lessonName):
	internalLessonName = lessonName
	if client.is_connected_to_host():
		client.put_string(internalLessonName)
	var error = wrapped_client.get_packet_error()
	if error != 0:
		push_error("Error on packet put: %s" % error)


func _on_ToolsButton_restart_tools():
	start()


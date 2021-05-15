#tool
extends Node

var lessonsFolder = "res://ServerFolder/Lessons/"

var sever
var file
var wrapped_peer
var port = 1236
var address = "127.0.0.1"

var is_ready = false

func start():
	wrapped_peer = PacketPeerStream.new()
	sever = TCP_Server.new()
	file = File.new()
	var error = sever.listen(port, address)
	if error != OK:
		push_error("An error occurred when sever tried listening to port.")
	
	is_ready = true


func _process(_delta):
	if(is_ready && sever && sever.is_connection_available()):
		print("Setver: Take Connection")
		var tsp_connection = sever.take_connection()
		if(tsp_connection && tsp_connection.get_available_bytes() > 0):
			var lessonName = tsp_connection.get_string()
			_send_lesson(lessonName, tsp_connection)


func _send_lesson(lessonName, tsp_connection):
	file.open(lessonsFolder + lessonName, File.READ)
	var data = file.get_buffer(wrapped_peer.output_buffer_max_size - 1)
	print("Server: Send file")
	wrapped_peer.put_packet (data)
	if(!file.eof_reached()):
		push_error("Cannot send file in one chunk")
	file.close()
	
	var error2 = wrapped_peer.get_packet_error()
	if error2 != 0:
		push_error("Error on packet put: %s" % error2)


func _on_ToolsButton_restart_tools():
	start()

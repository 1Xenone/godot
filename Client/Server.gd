#tool
extends Node

var sever = TCP_Server.new()
var file = File.new()
var wrapped_peer = PacketPeerStream.new()

var is_ready = false

func start():
	err(sever.listen(GV.port, GV.address))
	
	is_ready = true
	set_process(true)


func _process(_delta):
	if(is_ready && sever && sever.is_connection_available()):
		print("Setver: Take Connection")
		var tsp_connection = sever.take_connection()
		if(tsp_connection && tsp_connection.get_available_bytes() > 0):
			var lessonName = tsp_connection.get_string()
			_send_lesson(lessonName, tsp_connection)


func _send_lesson(lessonName, tsp_connection):
	err(file.open(GV.lessonsServerFolder + lessonName + GV.archiveType, File.READ))
	var data = file.get_buffer(wrapped_peer.output_buffer_max_size - 1)
	print("Server: Send file")
	wrapped_peer.stream_peer = tsp_connection
	wrapped_peer.put_var(lessonName + GV.archiveType)	
	wrapped_peer.put_packet (data)
	if(!file.eof_reached()):
		push_error("Cannot send file in one chunk")
	file.close()
	
	err(wrapped_peer.get_packet_error())


func _on_ToolsButton_restart_tools():
	start()

#include "networking_server.h"

#include "editor/editor_node.h"

NetworkingServer::NetworkingServer()
{
	ws_server = Ref<WebSocketServer>(WebSocketServer::create());
	// TODO: defene gloval variables
	ws_server->set_buffers(8192, 10, 8192, 10);
	ws_server->connect("data_received", callable_mp(this, &NetworkingServer::_on_task_requested));
}

//Bind all your methods used in this class
void NetworkingServer::_bind_methods()
{
	
}

void NetworkingServer::_on_task_requested(int id)
{
	const uint8_t* in_buffer;
	int size = 0;

	ws_server->get_peer(id)->get_packet(&in_buffer, size);

	String meaasge = String((char*)in_buffer);
	EditorNode::get_singleton()->show_warning(TTR("Error parsing JSON. Http request FAILED!"));
}



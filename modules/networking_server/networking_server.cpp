#include "networking_server.h"

#include "editor/editor_node.h"
#include <iostream>
#include <fstream>

NetworkingServer::NetworkingServer()
{
	Node::Node();

	this->connect("ready", callable_mp(this, &NetworkingServer::Ready));
}

void NetworkingServer::poll()
{
	if (ws_server.is_valid())
	{
		ws_server->poll();
	}
}

void NetworkingServer::_bind_methods()
{
	ClassDB::bind_method(D_METHOD("pollServer"), &NetworkingServer::poll);
}

void NetworkingServer::Ready()
{
	ws_server = Ref<WebSocketServer>(WebSocketServer::create());
	ws_server->set_buffers(8192, 10, 8192, 10);

	ws_server->connect("client_connected", callable_mp(this, &NetworkingServer::_peer_connected));
	ws_server->connect("client_disconnected", callable_mp(this, &NetworkingServer::_peer_disconnected));
	ws_server->connect("data_received", callable_mp(this, &NetworkingServer::_on_task_requested));

	Vector<String> protocols;
	protocols.push_back("binary"); // compatibility with EMSCRIPTEN TCP-to-WebSocket layer.
	int error = ws_server->listen(PORT, protocols);// protocols;
}

void NetworkingServer::_on_task_requested(int32_t id)
{
	const uint8_t* in_buffer;
	int size = 0;

	ws_server->get_peer(id)->get_packet(&in_buffer, size);

	String meaasge = String((char*)in_buffer);

	CharString cs = meaasge.utf8();

	SendTask(id, cs);
}

void NetworkingServer::_peer_connected(int p_id, String _protocol)
{
	peerId = p_id;
}

void NetworkingServer::_peer_disconnected(int p_id, bool p_was_clean)
{
}

void NetworkingServer::SendTask(int32_t id, CharString cs)
{
	std::ifstream src("C:\\Users\\artem\\Desktop\\godot\\TestServerClient\\lvl3.txt", std::ios::binary);
	std::cout <<  src.rdbuf()->;
	if (ws_server->get_peer(id)->put_packet((const uint8_t*)cs.ptr(), cs.length()) != Error::OK)
	{
		EditorNode::get_singleton()->show_warning(TTR("Error parsing JSON. No taskID"));
	}
}

//insert the Headername here
#ifndef NETWORKING_SERVER_H
#define NETWORKING_SERVER_H

#include "scene/main/node.h"
#include "modules/websocket/websocket_server.h"

class NetworkingServer : public Node
{
	GDCLASS(NetworkingServer, Node);

public:
	NetworkingServer();

	void poll();

protected:
	static void _bind_methods();

private:
	void Ready();

	void _on_task_requested(int32_t id);

	void _peer_connected(int p_id, String _protocol);
	void _peer_disconnected(int p_id, bool p_was_clean);

	void SendTask(int32_t id, CharString cs);


	Ref<WebSocketServer> ws_server;

	int peerId = 0;
	
	const int PORT = 1234;
};

#endif

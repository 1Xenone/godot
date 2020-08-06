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

protected:
	static void _bind_methods();

private:
	void _on_task_requested(int id);


	Ref<WebSocketServer> ws_server;
};

#endif

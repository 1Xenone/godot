//insert the Headername here
#ifndef NETWORKING_CLIENT_H
#define NETWORKING_CLIENT_H

#include "modules/websocket/wsl_client.h"
#include "scene/main/node.h"
#include "scene/main/http_request.h"

class NetworkingClient : public Node {
	GDCLASS(NetworkingClient, Node);

public:
	NetworkingClient();

	void SendTaskToServer();

	void RecieveResult();

protected:
	static void _bind_methods();

private:
	void _request_player_data();

	void _http_player_taskID_recieved(int p_status, int p_code, const PackedStringArray& headers, const PackedByteArray& p_data);

	void _request_player_task(String taskID);

	void _http_player_task_recieved(int p_status, int p_code, const PackedStringArray& headers, const PackedByteArray& p_data);

	void _on_connected_to_server();

	Dictionary _get_dictionary_from_http_request(int p_status, int p_code, const PackedByteArray& p_data);

	HTTPRequest *siteDownload;

	Ref<WebSocketClient> ws_client;

	const String playerID;

	const String siteAdress = "https://example.org/";

	// TODO: move to separate class
	String taskID;
};

#endif

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

	void Ready();

	void SendTaskToServer();

	void RecieveResult();

	void poll();

protected:
	static void _bind_methods();

private:
	void _request_player_data();

	void _http_player_taskID_recieved(int p_status, int p_code, const PackedStringArray& headers, const PackedByteArray& p_data);

	void _request_player_task(String taskID);

	void _player_task_recieved();

	void _on_connected_to_server(String protocol);

	Dictionary _get_result_from_http_request(int p_status, int p_code, const PackedByteArray& p_data);

	HTTPRequest *m_siteDownload;

	Ref<WebSocketClient> ws_client;
	Ref<WebSocketPeer> ws_peer;

	bool m_requestLvl = false;
	bool m_waitingForLvl = false;

	const String playerID = "1";

	const String siteAdress = "https://4ff31b69-aab3-4926-8580-ad11dc238177.mock.pstmn.io/user";

	// TODO: move to separate class
	String taskID;
};

#endif

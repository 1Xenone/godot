#include "networking_client.h"

#include "core/io/json.h"
#include "editor/editor_node.h"

NetworkingClient::NetworkingClient()
{
	siteDownload = memnew(HTTPRequest);
	add_child(siteDownload);
	siteDownload->connect("request_completed", callable_mp(this, &NetworkingClient::_http_player_taskID_recieved));
	_request_player_data();
}

void NetworkingClient::_bind_methods()
{

}

void NetworkingClient::_request_player_task(String taskID)
{
	this->taskID = taskID;
	Vector<String> protocols;
	protocols.push_back("binary"); // Compatibility for emscripten TCP-to-WebSocket.

	ws_client = Ref<WebSocketClient>(memnew(WSLClient));
	// TODO: defene gloval variables
	ws_client->set_buffers(8192, 10, 8192, 10);

	int error = ws_client->connect_to_url("ws://echo.websocket.org", protocols);
	if (error != OK)
	{
		EditorNode::get_singleton()->show_warning(TTR("Unable connect to server. Status: " + String::num(ws_client->get_connection_status())));
		return;
	}

	ws_client->connect("connection_established", callable_mp(this, &NetworkingClient::_on_connected_to_server));

}

void NetworkingClient::_on_connected_to_server()
{
	CharString cs = taskID.utf8();
	// TODO: encoding. See put32 method

	ws_client->get_peer(1)->put_packet((const uint8_t*)cs.ptr(), cs.length());
}

void NetworkingClient::_request_player_data()
{
	Vector<String> playerIdHeader;
	playerIdHeader.push_back("PlayerID: " + playerID);
	siteDownload->request(siteAdress, playerIdHeader);
}


void NetworkingClient::_http_player_taskID_recieved(int p_status, int p_code, const PackedStringArray &headers, const PackedByteArray &p_data)
{
	Dictionary dictionary = _get_dictionary_from_http_request(p_status, p_code, p_data);

	if (dictionary.has("taskID"))
	{
		String taskID = dictionary["taskID"];
		_request_player_task(taskID);
	}
	else
	{
		EditorNode::get_singleton()->show_warning(TTR("Error parsing JSON. No taskID"));
	}
}


Dictionary NetworkingClient::_get_dictionary_from_http_request(int p_status, int p_code, const PackedByteArray& p_data)
{
	if (p_status != HTTPRequest::RESULT_SUCCESS || p_code != 200)
	{
		EditorNode::get_singleton()->show_warning(TTR("Error parsing JSON. Http request FAILED!"));
		return Dictionary();
	}

	String mirror_str;
	{
		const uint8_t* r = p_data.ptr();
		mirror_str.parse_utf8((const char*)r, p_data.size());
	}

	Variant result;
	String errs;
	int errline;
	Error err = JSON::parse(mirror_str, result, errs, errline);
	if (err != OK)
	{
		EditorNode::get_singleton()->show_warning(TTR("Error parsing JSON. Parsing FAILED!"));
		return Dictionary();
	}

	return result;
}

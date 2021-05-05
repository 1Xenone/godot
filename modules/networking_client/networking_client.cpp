#include "networking_client.h"

#include "core/io/json.h"
#include "editor/editor_node.h"

NetworkingClient::NetworkingClient()
{
	Node::Node();

	this->connect("ready", callable_mp(this, &NetworkingClient::Ready));
}

void NetworkingClient::Ready()
{
	m_siteDownload = memnew(HTTPRequest);
	add_child(m_siteDownload);
	m_siteDownload->connect("request_completed", callable_mp(this, &NetworkingClient::_http_player_taskID_recieved));
	m_siteDownload->connect("data_received", callable_mp(this, &NetworkingClient::_player_task_recieved));
	_request_player_data();

	ws_client = Ref<WebSocketClient>(WebSocketClient::create());
	ws_client->set_buffers(8192, 10, 8192, 10);
}

void NetworkingClient::poll()
{
	ws_client->poll();

	if (!m_requestLvl)
	{
		_request_player_data();
	}

	if (!ws_client->get_peer(1).is_null())
	{
		int a = ws_client->get_peer(1)->get_available_packet_count();
		if (a > 0)
		{
			const uint8_t* in_buffer;
			int size = 0;
			int a = ws_client->get_peer(1)->get_packet(&in_buffer, size);

			String meaasge = String((char*)in_buffer);

			CharString cs = meaasge.utf8();
		}
	}
}

void NetworkingClient::_bind_methods()
{
	ClassDB::bind_method(D_METHOD("pollClient"), &NetworkingClient::poll);
}

void NetworkingClient::_request_player_task(String taskID)
{
	this->taskID = taskID;
	Vector<String> protocols;
	protocols.push_back("binary"); // Compatibility for emscripten TCP-to-WebSocket.

	ws_client = Ref<WebSocketClient>(memnew(WSLClient));
	// TODO: defene gloval variables
	ws_client->set_buffers(8192, 10, 8192, 10);

	int error = ws_client->connect_to_url("ws://localhost:1234", protocols);
	if (error != OK)
	{
		EditorNode::get_singleton()->show_warning(TTR("Unable connect to server. Status: " + String::num(ws_client->get_connection_status())));
		return;
	}

	ws_client->connect("connection_established", callable_mp(this, &NetworkingClient::_on_connected_to_server));


	if (ws_client->get_connection_status() == WebSocketClient::CONNECTION_DISCONNECTED) {
		ERR_PRINT("Remote Debugger: Unable to connect. Status: " + String::num(ws_client->get_connection_status()) + ".");
	}
}




void NetworkingClient::_on_connected_to_server(String protocol)
{
	ws_peer = ws_client->get_peer(1);

	ERR_FAIL_COND(!ws_peer.is_valid());
	ERR_FAIL_COND(!ws_peer->is_connected_to_host());

	CharString cs = taskID.utf8();
	// TODO: encoding. See put32 method

	if (ws_peer->put_packet((const uint8_t*)cs.ptr(), cs.length()) != Error::OK)
	{
		EditorNode::get_singleton()->show_warning(TTR("Error parsing JSON. No taskID"));
	}
}

void NetworkingClient::_request_player_data()
{
	String body = "PlayerID=" + playerID;
	m_siteDownload->request(siteAdress + "?" + body);

	m_requestLvl = true;
}


void NetworkingClient::_http_player_taskID_recieved(int p_status, int p_code, const PackedStringArray &headers, const PackedByteArray &p_data)
{
	Dictionary dictionary = _get_result_from_http_request(p_status, p_code, p_data);

	if (dictionary.has("Lvl"))
	{
		String taskID = dictionary["Lvl"];
		_request_player_task(taskID);
	}
	else
	{
		EditorNode::get_singleton()->show_warning(TTR("Error parsing JSON. No taskID"));
	}
}

void NetworkingClient::_player_task_recieved()
{
	const uint8_t* buffer;
	int buffer_size;
	ws_client->get_peer(1)->get_packet(&buffer, buffer_size);

	printf((const char*)buffer);
}


Dictionary NetworkingClient::_get_result_from_http_request(int p_status, int p_code, const PackedByteArray& p_data)
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

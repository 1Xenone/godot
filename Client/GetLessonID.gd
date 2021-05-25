#tool
extends Node
signal open_lesson(lessonID)

func start():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

	err(http_request.request("https://4ff31b69-aab3-4926-8580-ad11dc238177.mock.pstmn.io/user?PlayerID=1"))

func _http_request_completed(_result, _response_code, _headers, body):
	var response = parse_json(body.get_string_from_utf8())
	var lvl = response["Lvl"]
	print("Http got lvlID : " + lvl)
	emit_signal("open_lesson", lvl)


func _on_ToolsButton_restart_tools():
	start()

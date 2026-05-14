extends BasicScene

#region Declarations
@export var send_button : Button
@export var chat_text : TextEdit
@export var chat_log : RichTextLabel
@export var player_list : VBoxContainer
#endregion

#region Events
func _ready() -> void:
	scene_data.set("game_type", Genum.GameType.MURDER_TOWN)
	
	GameGlobalEvents.player_connected.connect(_on_player_connected)
	GameGlobalEvents.chat_recieved.connect(_on_chat_recieved)
	send_button.pressed.connect(_on_send_pressed)
	
	if not multiplayer.is_server():
		for player in GameGlobal.multi.connected_clients.values():
			_create_player_label(player.get("name"))

func _create_player_label(player_name: String) -> void:
	var label := Label.new()
	label.text = player_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	player_list.add_child(label)
#endregion

#region Signal Callbacks
func _on_player_connected(_peer_id: int, player_info: Dictionary[String, Variant]) -> void:
	_create_player_label(player_info.get("name"))

func _on_send_pressed() -> void:
	var message = chat_text.text
	chat_text.text = ""
	GameGlobal.multi.send_chat.rpc(message)
	_on_chat_recieved(GameGlobal.multi.multi_info.get("name"), message)

func _on_chat_recieved(sender_name, message) -> void:
	var current_chat = chat_log.text
	var parsed_message = "%s: %s" % [sender_name, message]
	if current_chat == "":
		current_chat = parsed_message
	else:
		current_chat += "\n%s" % parsed_message
	chat_log.text = current_chat
#endregion

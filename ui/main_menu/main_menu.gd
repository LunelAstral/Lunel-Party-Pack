extends CanvasLayer

#region Declarations
@onready var server_container : PanelContainer = $JoinContainer
@onready var server_list : VBoxContainer = $JoinContainer/MarginContainer/ServerList
#endregion

#region Events
func _ready() -> void:
	server_container.hide()

func _generate_server_buttons() -> void:
	for child in server_list.get_children():
		server_list.remove_child(child)
		child.queue_free()
	
	GameGlobal.find_servers()
	GameGlobalEvents.new_server.connect(_on_server_found)

func _add_server_button(ip: String) -> void:
	var found_duplicate := false
	for child in server_list.get_children():
		if child.text == ip:
			found_duplicate = true
			break
	
	if found_duplicate:
		return
	
	var server_button := Button.new()
	server_button.text = ip
	server_button.pressed.connect(_on_connect_pressed.bind(ip))
	server_list.add_child(server_button)
#endregion

#region Signal Callbacks
func _on_join_pressed():
	server_container.show()
	_generate_server_buttons()

func _on_host_pressed():
	GameGlobal.host_server()
	GameGlobal.sm.transition_to_scene("res://scenes/town_murder/towny_lobby.tscn", {})

func _on_connect_pressed(ip: String):
	GameGlobal.join_server(ip)

func _on_server_found(ip: String):
	_add_server_button(ip)
#endregion

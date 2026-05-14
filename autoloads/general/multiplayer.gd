class_name LPPMultiplayer extends Node

#region Declarations
const CONNECTION_TIMEOUT : int = 5
const BROADCAST_INTERVAL : int = 1

var connected_clients : Dictionary[int, Dictionary] = {}
var listening := false
var known_servers : Dictionary[String, Dictionary] = {}
var multi_info : Dictionary[String, Variant] = {}
var _socket := PacketPeerUDP.new()
var _ip : String = "localhost"
var _port : int = 8910
var _d_port : int = 8911
var _max_clients : int = 8
var _multi_timer := Timer.new()
#endregion

#region Events
func _ready() -> void:
	_signal_initialization()

func _process(_delta) -> void:
	if not listening:
		return
	
	if _socket.get_available_packet_count() > 0:
		var server_ip := _socket.get_packet_ip()
		var packet := _socket.get_packet()
		
		if server_ip == "":
			return
		
		if known_servers.has(server_ip):
			return
		
		var message = bytes_to_var(packet)
		known_servers.set(server_ip, message)
		GameGlobalEvents.new_server.emit(server_ip)
#endregion

#region Multiplayer Events
func start_server(port: int=_port, listen_port: int=_d_port, max_clients: int=_max_clients) -> void:
	_port = port
	_d_port = listen_port
	
	_multi_timer.wait_time = BROADCAST_INTERVAL
	_multi_timer.one_shot = false
	_multi_timer.autostart = true
	add_child(_multi_timer)
	_multi_timer.timeout.connect(_broadcast)
	
	_max_clients = max_clients
	_socket.set_broadcast_enabled(true)
	_socket.set_dest_address("255.255.255.255", _d_port)
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(_port, _max_clients)
	
	if error == OK:
		multiplayer.multiplayer_peer = peer
		print("Created server on port: %s" % _port)
	else:
		print("Failed to create server: %s" % error)

func join_server(ip: String=_ip, port: int=_port) -> void:
	_ip = ip
	_port = port
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(_ip, _port)
	
	if error == OK:
		multiplayer.multiplayer_peer = peer
		print("Connecting...")
	else:
		print("Failed to connect to %s: %s" % [_ip, error])

func detect_servers_lan(port: int) -> void:
	_d_port = port
	
	var socket_error = _socket.bind(_d_port)
	
	if socket_error == OK:
		print("Listening on port: %s" % _d_port)
	else:
		print("Error listening on port %s: %s" % [_d_port, socket_error])
	listening = true

func _signal_initialization() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
#endregion

#region RPCs
@rpc("any_peer", "reliable")
func send_chat(message: String) -> void:
	var sender_id = multiplayer.get_remote_sender_id()
	var sender_name = connected_clients.get(sender_id).get("name")
	GameGlobalEvents.chat_recieved.emit(sender_name, message)

@rpc("any_peer", "reliable")
func _register_player(new_player_info) -> void:
	var new_player_id = multiplayer.get_remote_sender_id()
	connected_clients.set(new_player_id, new_player_info)
	GameGlobalEvents.player_connected.emit(new_player_id, new_player_info)
#endregion

#region Signal Callbacks
func _on_connected_to_server() -> void:
	print("Successfully connected to %s" % _ip)
	GameGlobalEvents.connected_to_server.emit()
	listening = false

func _broadcast() -> void:
	var packet := var_to_bytes(multi_info)
	print("Broadcasting...")
	_socket.put_packet(packet)

func _on_timeout() -> void:
	_multi_timer.timeout.disconnect(_on_timeout)
	remove_child(_multi_timer)

func _on_player_connected(id) -> void:
	_register_player.rpc_id(id, multi_info)
#endregion

class_name LPPMultiplayer extends Node

#region Declarations
var _ip : String = "localhost"
var _port : int = 8910
var _max_clients : int = 8
#endregion

#region Events
func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)

func start_server(port: int, max_clients: int) -> void:
	_port = port
	_max_clients = max_clients
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(_port, _max_clients)
	
	if error == OK:
		multiplayer.multiplayer_peer = peer
		print("Created server on port: %s" % _port)
	else:
		print("Failed to create server: %s" % error)

func join_server(ip: String, port: int) -> void:
	_ip = ip
	_port = port
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(_ip, _port)
	
	if error == OK:
		multiplayer.multiplayer_peer = peer
		print("Connecting...")
	else:
		print("Failed to connect to %s: %s" % [_ip, error])
#endregion

#region Signal Callbacks
func _on_connected_to_server() -> void:
	print("Successfully connected to %s" % _ip)
#endregion

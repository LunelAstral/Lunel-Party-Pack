## The actual Global containing all of the game's core information.
extends Node

#region Declarations
const DEFAULT_PORT : int = 8910
const DEFAULT_DISCOVERY_PORT : int = 8911
const MAX_CLIENTS = 8

@onready var multi : LPPMultiplayer = $Multiplayer
#endregion

#region Multiplayer Events
func set_multiplayer_info(data: Dictionary[String, Variant]) -> void:
	multi.multi_info = data

func host_server() -> void:
	set_multiplayer_info({"Name": "GameServer"})
	multi.start_server(DEFAULT_PORT, DEFAULT_DISCOVERY_PORT, MAX_CLIENTS)

func join_server(ip: String) -> void:
	set_multiplayer_info({"Name": "Player"})
	multi.join_server(ip, DEFAULT_PORT)

func find_servers():
	multi.detect_servers_lan(DEFAULT_DISCOVERY_PORT)
#endregion

#region Helpers
func delay(time: float) -> void:
	await get_tree().create_timer(time).timeout
#endregion

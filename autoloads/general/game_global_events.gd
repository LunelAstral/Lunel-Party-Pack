## This is where all the main and common signals are located, otherwise referred to as a SignalBus
extends Node
@warning_ignore_start("unused_signal")

#region Multiplayer Signals
signal new_server(server_ip: String)
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected
#endregion

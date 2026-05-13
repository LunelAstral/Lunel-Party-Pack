## The actual Global containing all of the game's core information.
extends Node

#region Declarations
const MAX_CLIENTS = 8

@onready var multi : LPPMultiplayer = $Multiplayer
#endregion

#region Events
func host_server() -> void:
	multi.start_server(8910, 8)

func join_server() -> void:
	multi.join_server("localhost", 8910)
#endregion

#region Helpers
func delay(time: float) -> void:
	await get_tree().create_timer(time).timeout
#endregion

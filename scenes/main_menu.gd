extends BasicScene

#region Declarations
@export_file var murder_town_lobby : String = ""
#endregion

#region Events
func _ready() -> void:
	GameGlobalEvents.connected_to_server.connect(_on_connected)
#endregion

#region Signal Callbacks
func _on_connected() -> void:
	if murder_town_lobby == "":
		GameGlobal.log_sys.warn(self, "There is no murder_town_lobby assigned.")
		return
	
	to_new_scene(murder_town_lobby)
#endregion

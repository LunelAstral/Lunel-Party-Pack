extends CanvasLayer

#region Events
#endregion

#region Signal Callbacks
func _on_join_pressed():
	GameGlobal.join_server()

func _on_host_pressed():
	GameGlobal.host_server()
#endregion

class_name BasicScene extends Node

#region Declarations
@export var scene_data : Dictionary[String, Variant] = {
	"scene_name": "Basic Scene"
}
#endregion

#region Events
func to_new_scene(path: String) -> void:
	GameGlobal.sm.transition_to_scene(path, scene_data)

func load_scene_data(data: Dictionary[String, Variant]) -> void:
	scene_data = data
#endregion

class_name SceneManager extends Node

#region Declarations
var main_scene : Node
#endregion

#region Events
func transition_to_scene(scene: String, data: Dictionary[String, Variant]) -> void:
	if not main_scene:
		return
	
	var next_scene : BasicScene = load(scene).instantiate()
	for child in main_scene.get_children():
		main_scene.remove_child(child)
	
	next_scene.load_scene_data(data)
	main_scene.add_child(next_scene)
#endregion

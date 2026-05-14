class_name LogSystem extends Node

#region Events
func warn(node: Node, message: String) -> void:
	push_warning("@%s encountered error: %s" % [node.get_path(), message])
#endregion

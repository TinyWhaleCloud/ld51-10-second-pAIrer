class_name ProfileCard
extends BaseCard

func _enter_tree() -> void:
    add_to_group("ProfileCards")

func _exit_tree() -> void:
    remove_from_group("ProfileCards")

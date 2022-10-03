tool
class_name BaseDateCard
extends BaseCard

func _enter_tree() -> void:
    add_to_group("DateCards")

func _exit_tree() -> void:
    remove_from_group("DateCards")

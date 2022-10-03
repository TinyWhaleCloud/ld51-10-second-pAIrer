tool
class_name ProfileCard
extends BaseCard

onready var description_label := $DescriptionLabel as Label

# Visible card properties
export(String, MULTILINE) var description := "Example\nText" setget set_description

# Invisible card properties
export(Array, String) var likes_profiles := []
export(Array, String) var likes_date_ideas := []
export(Array, String) var dislikes_profiles := []
export(Array, String) var dislikes_date_ideas := []

func _ready() -> void:
    self.description = description

func set_description(_value: String) -> void:
    description = _value
    if description_label:
        description_label.text = description

func _enter_tree() -> void:
    add_to_group("ProfileCards")

func _exit_tree() -> void:
    remove_from_group("ProfileCards")

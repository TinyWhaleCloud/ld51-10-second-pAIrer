class_name ProfileCard
extends Area2D

# Card/profile properties
export var card_title := "Example"

# Whether the card can be selected by the player
var selectable := true

func _ready() -> void:
    $TitleLabel.text = card_title

func _enter_tree() -> void:
    add_to_group("ProfileCards")

func _exit_tree() -> void:
    remove_from_group("ProfileCards")

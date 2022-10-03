tool
class_name ProfileCard
extends BaseCard

onready var description_label := $DescriptionLabel as Label

# Visible card properties
export(String, MULTILINE) var description := "Example\nText" setget set_description

# Invisible card properties
export(Array, String, "Ash", "Bastri", "Caroline", "CatrinaFish", "Chad", "Frank", "Grace", "Hannah", "Hyper", "MissNo", "Sebbi", "Waldo") var likes_profiles := []
export(Array, String, "Ash", "Bastri", "Caroline", "CatrinaFish", "Chad", "Frank", "Grace", "Hannah", "Hyper", "MissNo", "Sebbi", "Waldo") var dislikes_profiles := []
export(Array, String, "Beach", "Cinema", "Club", "Hackspace", "London", "Paris", "Pisa", "TheMoon") var likes_locations := []
export(Array, String, "Beach", "Cinema", "Club", "Hackspace", "London", "Paris", "Pisa", "TheMoon") var dislikes_locations := []
export(Array, String, "ARGame", "Cycling", "GameJam", "Gaming", "GettingASnack", "GettingCoffee", "Sightseeing", "WatchingAFilm") var likes_activities := []
export(Array, String, "ARGame", "Cycling", "GameJam", "Gaming", "GettingASnack", "GettingCoffee", "Sightseeing", "WatchingAFilm") var dislikes_activities := []

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

tool
class_name BaseCard
extends Area2D

# Card properties
export(String) var card_title := "Example" setget set_card_title
export(Texture) var card_picture: Texture setget set_card_picture

# Whether the card can be selected by the player
var selectable := true

func set_card_title(_title: String) -> void:
    card_title = _title
    $TitleLabel.text = card_title

func set_card_picture(_texture: Texture) -> void:
    card_picture = _texture
    $CardPicture.texture = _texture

func remove_from_parent() -> void:
    if get_parent():
        get_parent().remove_child(self)

func slide_to_position(new_position: Vector2, duration: float = 0.3) -> void:
    var tween := get_tree().create_tween()
    tween.set_trans(Tween.TRANS_SINE)
    tween.tween_property(self, "position", new_position, duration)

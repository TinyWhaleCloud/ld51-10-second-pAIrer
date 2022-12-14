class_name BaseCardSlot
extends Node2D

# Whether there is a card in this slot
var is_occupied := false

# Which card lies in this slot
var current_card: BaseCard = null

func set_card(card: BaseCard) -> void:
    assert(current_card == null)

    current_card = card
    is_occupied = true

    card.position = self.position

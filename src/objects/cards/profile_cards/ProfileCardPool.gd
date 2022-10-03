class_name ProfileCardPool
extends BaseCardPool

func remove_from_pool(_card_name: String) -> void:
    for card in get_children():
        if card.name == _card_name:
            remove_child(card)
            break

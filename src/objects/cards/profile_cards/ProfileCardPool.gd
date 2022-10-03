class_name ProfileCardPool
extends Node

var rng := RandomNumberGenerator.new()

# Array of shuffled cards to draw from
var shuffled_stack := []

func _init() -> void:
    rng.randomize()

func shuffle() -> void:
    print_debug("Shuffling profile card stack... (Current pool size: %d)" % current_pool_size())
    shuffled_stack = get_children()
    shuffled_stack.shuffle()

func current_pool_size() -> int:
    return get_child_count()

func shuffled_stack_size() -> int:
    return shuffled_stack.size()

func draw_card() -> ProfileCard:
    var random_card = shuffled_stack.pop_back()
    return random_card.duplicate() if random_card else null

func remove_from_pool(_card_name: String) -> void:
    for card in get_children():
        if card.name == _card_name:
            remove_child(card)
            break

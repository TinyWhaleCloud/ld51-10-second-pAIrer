class_name BaseCardPool
extends Node

# Array of shuffled cards to draw from
var shuffled_stack := []

func _init() -> void:
    randomize()

func shuffle() -> void:
    print_debug("Shuffling %s card stack... (Current pool size: %d)" % [name, current_pool_size()])
    shuffled_stack = get_children()
    shuffled_stack.shuffle()

func current_pool_size() -> int:
    return get_child_count()

func shuffled_stack_size() -> int:
    return shuffled_stack.size()

func draw_card() -> BaseCard:
    var random_card = shuffled_stack.pop_back()
    return random_card.duplicate() if random_card else null

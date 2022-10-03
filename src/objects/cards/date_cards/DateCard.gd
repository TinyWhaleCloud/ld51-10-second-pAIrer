class_name DateCard
extends BaseCard

# Date card types
enum DateCardType {UNKNOWN = 0, DATE_LOCATION, DATE_ACTIVITY}

# Card properties
export(DateCardType) var date_card_type := DateCardType.UNKNOWN

func _enter_tree() -> void:
    add_to_group("DateCards")

func _exit_tree() -> void:
    remove_from_group("DateCards")

func is_date_location() -> bool:
    return date_card_type == DateCardType.DATE_LOCATION

func is_date_activity() -> bool:
    return date_card_type == DateCardType.DATE_ACTIVITY

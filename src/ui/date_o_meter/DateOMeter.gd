tool
class_name DateOMeter
extends Node2D

onready var needle := $Needle as Node2D
onready var tween := $NeedleTween as Tween

const GAUGE_MAX_SCORE := 140
const GAUGE_MAX_ANGLE := PI / 4

# Worst case: -180 points (although the date-o-meter only goes to -140, so the needle breaks out)
# Best case: +140 points
export(int, -180, 140) var score := 0 setget set_score

func _ready() -> void:
    self.score = score

func set_score(_score: int) -> void:
    score = _score
    if needle:
        needle.rotation = get_angle_for_score(score)

func get_angle_for_score(_score: int) -> float:
    return GAUGE_MAX_ANGLE * float(score) / GAUGE_MAX_SCORE

func move_to_new_score(_new_score: int) -> void:
    tween.interpolate_property(
        self, "score",
        score, _new_score, 3.0,
        Tween.TRANS_ELASTIC, Tween.EASE_OUT
    )
    tween.start()

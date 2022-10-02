class_name Player
extends KinematicBody2D

# Constants
# TODO: Find optimal player speed
const PLAYER_SPEED = 600
const HUD_DEAD_ZONE = 64

# Node references
onready var sprite := $Sprite as AnimatedSprite

# Internal state
var _movement_area: Rect2

func _ready() -> void:
    # Calculate movement area
    var screen_size := get_viewport_rect().size
    var sprite_size := Vector2(64, 128)
    _movement_area = Rect2(
        sprite_size.x / 2,
        sprite_size.y / 2 + HUD_DEAD_ZONE,
        screen_size.x - sprite_size.x,
        screen_size.y - sprite_size.y - HUD_DEAD_ZONE
    )

func _process(delta: float) -> void:
    handle_movement(delta)

func handle_movement(delta: float) -> void:
    var velocity := Vector2.ZERO
    if Input.is_action_pressed("move_left"):
        velocity.x -= 1
    if Input.is_action_pressed("move_right"):
        velocity.x += 1
    if Input.is_action_pressed("move_up"):
        velocity.y -= 1
    if Input.is_action_pressed("move_down"):
        velocity.y += 1

    if velocity.length() > 0:
        velocity = velocity.normalized() * PLAYER_SPEED

    position += velocity * delta
    position.x = clamp(position.x, _movement_area.position.x, _movement_area.end.x)
    position.y = clamp(position.y, _movement_area.position.y, _movement_area.end.y)

    if velocity.x != 0 || velocity.y != 0:
        rotation = velocity.angle()
        if !sprite.playing:
            sprite.play()
    elif sprite.playing:
        sprite.stop()
        sprite.set_frame(0)

func reset_position() -> void:
    position = Vector2(640, 480)

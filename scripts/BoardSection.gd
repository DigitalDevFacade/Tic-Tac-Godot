extends Area2D

signal pressed;

export(bool) var OCCUPIED = false;

onready var sprite = $Sprite;
const O_TEXTURE = preload("res://sprites/o.png");
const X_TEXTURE = preload("res://sprites/x.png");

func _on_BoardSection_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("ui_click"):
		emit_signal("pressed")

func handle_player_choice(player):
	if OCCUPIED:
		return false;
	else:
		sprite.texture = X_TEXTURE if player == "X" else O_TEXTURE;
		OCCUPIED = true;
		return true;

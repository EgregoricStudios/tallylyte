extends Area2D

var perfectguarding: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hurt(hit_for:float):
	print("transfer worked ", hit_for)
	$"..".taken_damage(hit_for)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	perfectguarding = $"../../CharacterBody2D/P1Glob".perfectguarding

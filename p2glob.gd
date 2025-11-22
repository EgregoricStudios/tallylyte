class_name p2glob extends Node
# State Machine Prototype 0.0.0.0a ("Fine Moy I'll do it")

var dead: bool = false
var attacking: bool = false
var can_combo: bool = false
var perfectguarding: bool = false
var guarding: bool = false
var hurting: bool = false
var player2: Node2D
var player2animator: Node2D
enum p2States {p2dead, p2attacking, p2guarding, p2hurting, p2idle}
var state: int = p2States.p2idle
var combo_state
var last_attack: String= ""


func _ready():
	player2 = $".."
	player2animator = $"../AnimatedSprite2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	state_check()

func combo_state_check():
	# output value is the name of the next available attack in the string
	if !can_combo:
		last_attack = ""
		combo_state = ""
		return
	print(can_combo)
	if last_attack == "light":
		combo_state = "attack_combo_1_1"
	

func state_check():
	if !player2animator.is_playing():
		if state == p2States.p2attacking:
			attacking = false
		if state == p2States.p2hurting:
			hurting = false
		if state == p2States.p2guarding and !Input.is_action_pressed("guard"):
			guarding = false
	if dead:
		state = p2States.p2dead
		return
	if !attacking:
		if !hurting:
			if !guarding:
				state = p2States.p2idle
				return
	if hurting:
		state = p2States.p2hurting
		return
	if guarding:
		state = p2States.p2guarding
		return
	if attacking:
		state = p2States.p2attacking

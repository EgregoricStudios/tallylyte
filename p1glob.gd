class_name p1glob extends Node
# State Machine Prototype 0.0.0.0a ("Fine Moy I'll do it")

var dead: bool = false
var attacking: bool = false
var can_combo: bool = false
var perfectguarding: bool = false
var guarding: bool = false
var hurting: bool = false
var player1: Node2D
var player1animator: Node2D
enum P1States {p1dead, p1attacking, p1guarding, p1hurting, p1idle}
var state: int = P1States.p1idle
var combo_state
var last_attack: String= ""


func _ready():
	player1 = $".."
	player1animator = $"../AnimatedSprite2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	state_check()

func combo_state_check():
	# output value is the name of the next available attack in the string
	if !can_combo:
		last_attack = ""
		combo_state = ""
		return
	if last_attack == "light":
		combo_state = "attack_combo_1_1"
	

func state_check():
	if !player1animator.is_playing():
		if state == P1States.p1attacking:
			attacking = false
		if state == P1States.p1hurting:
			hurting = false
		if state == P1States.p1guarding and !Input.is_action_pressed("guard"):
			guarding = false
	if dead:
		state = P1States.p1dead
		return
	if !attacking:
		if !hurting:
			if !guarding:
				state = P1States.p1idle
				return
	if hurting:
		state = P1States.p1hurting
		return
	if guarding:
		state = P1States.p1guarding
		return
	if attacking:
		state = P1States.p1attacking

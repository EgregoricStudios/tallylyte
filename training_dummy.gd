extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var hitpoints: float = (10)
var block_reduction: float = 1
var standardcombotime: float = .3333
var shortcombotime: float = 0.08
var longcombotime: float = .5

@onready var P2Glob: Node2D = $p2glob
@onready var possible_states = p2glob.p2States
@onready var animator = $AnimatedSprite2D
@onready var puncher = $RayCast2D
@onready var combo_1_1kicker = $RayCastTestKick

#credit to Aruko for getting me to have damage call hurt function directly

func taken_damage(damage_just_taken: float):
	if P2Glob.dead:
		return
	print("taken damage ", damage_just_taken)
	var final_damage = damage_just_taken * block_reduction
	if final_damage > 0:
		hitpoints -= final_damage
		if final_damage >= 2 and hitpoints > 0:
			animator.play("hurt")
			P2Glob.hurting = true
		if hitpoints <= 0:
			animator.play("die")
			P2Glob.dead = true

func guard():
	block_reduction = 0.1
	P2Glob.guarding = true
	animator.play("guard")
	P2Glob.perfectguarding = true
	await animator.frame_changed
	await animator.frame_changed
	P2Glob.perfectguarding = false 

func attack(damage_outgoing: float):
	
	print("attack() fired")
	$Timer.stop()
	animator.play("attack")
	print(animator.get_animation())
	P2Glob.attacking = true
	P2Glob.can_combo = true 
	while animator.frame < 4 and animator.is_playing():
		await animator.frame_changed
	if puncher.is_colliding():
		if puncher.get_collider().perfectguarding:
			animator.play("hurt")
			P2Glob.hurting = true
		else:
			puncher.get_collider().hurt(damage_outgoing)
	P2Glob.last_attack = "light"
	await animator.animation_finished
	
	$Timer.start(standardcombotime)
	print($Timer.is_stopped())
	print(P2Glob.can_combo)
	print("was it me uwu")

func attack_combo_1_1(damage_outgoing: float):
	$Timer.stop()
	animator.play("attack_combo_1_1")
	P2Glob.attacking = true
	P2Glob.can_combo = true 
	while animator.frame < 5 and animator.is_playing():
		await animator.frame_changed 
	if (!animator.is_playing() and P2Glob.state == possible_states.p2attacking):
		breakpoint
	if combo_1_1kicker.is_colliding() and P2Glob.state == possible_states.p2attacking:
		combo_1_1kicker.get_collider().hurt(damage_outgoing)
	await animator.animation_finished
	$Timer.start(standardcombotime)
	print(P2Glob.state)

func _on_timer_timeout():
	print(P2Glob.can_combo)
	P2Glob.can_combo = false
	print(P2Glob.can_combo)
	print("can't combo")

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2
	if P2Glob.state == possible_states.p2dead:
		return
	P2Glob.state_check()
	if P2Glob.state == possible_states.p2idle:
		if Input.is_action_just_pressed("p2up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("selfhurt") and !Input.is_action_just_pressed("selfhurt_big"):
			taken_damage(1)
		if Input.is_action_just_pressed("selfhurt_big"):
			taken_damage(3.34)
		if Input.is_action_just_pressed("p2light"):
			if P2Glob.can_combo:
				P2Glob.combo_state_check()
				if P2Glob.combo_state == "attack_combo_1_1":
					attack_combo_1_1(6.67)
			else:
				attack(3.34)
		if Input.is_action_just_pressed("p2guard"):
			guard()
	if $Timer.time_left > 0:
		print($Timer.time_left)
	if P2Glob.guarding and !Input.is_action_pressed("p2guard"):
		P2Glob.guarding = false
		block_reduction = 1
	P2Glob.state_check()
	var direction = Input.get_axis("p2left", "p2right")
	if P2Glob.state == possible_states.p2idle and !animator.is_playing():
		animator.play("idle")
	if direction and P2Glob.state == possible_states.p2idle:
		velocity.x = direction * SPEED
		print(P2Glob.state)
		print("my bad")
		animator.play("walk")
	if !direction or (P2Glob.state != possible_states.p2idle and is_on_floor()):
		velocity.x = move_toward(velocity.x, 0, SPEED)


	# temp for testing sprites
	if $AnimatedSprite2D.get_animation() == "idle":
		pass
		$AnimatedSprite2D.scale = Vector2(1,1)
	else:
		$AnimatedSprite2D.scale = Vector2(0.18,0.18)

	move_and_slide()

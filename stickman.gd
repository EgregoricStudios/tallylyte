extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var hitpoints: float = (10)
var block_reduction: float = 1
var standardcombotime: float = .3333
var shortcombotime: float = 0.08
var longcombotime: float = .5

@onready var P1Glob: Node2D = $P1Glob
@onready var possible_states = p1glob.P1States
@onready var animator = $AnimatedSprite2D
@onready var puncher = $RayCast2D
@onready var combo_1_1kicker = $RayCastTestKick

#credit to Aruko for getting me to have damage call hurt function directly

func taken_damage(damage_just_taken: float):
	if P1Glob.dead:
		return
	print("taken damage ", damage_just_taken)
	var final_damage = damage_just_taken * block_reduction
	if final_damage > 0:
		hitpoints -= final_damage
		if final_damage >= 2 and hitpoints > 0:
			animator.play("hurt")
			P1Glob.hurting = true
		if hitpoints <= 0:
			animator.play("die")
			P1Glob.dead = true

func guard():
	block_reduction = 0.1
	P1Glob.guarding = true
	animator.play("guard")
	P1Glob.perfectguarding = true
	await animator.frame_changed
	await animator.frame_changed
	P1Glob.perfectguarding = false 

func attack(damage_outgoing: float):
	
	print("attack() fired")
	$Timer.stop()
	animator.play("attack")
	print(animator.get_animation())
	P1Glob.attacking = true
	P1Glob.can_combo = true 
	while animator.frame < 4 and animator.is_playing():
		await animator.frame_changed
	if puncher.is_colliding():
		if puncher.get_collider().perfectguarding:
			animator.play("hurt")
			P1Glob.hurting = true
		else:
			puncher.get_collider().hurt(damage_outgoing)
	P1Glob.last_attack = "light"
	await animator.animation_finished
	
	$Timer.start(standardcombotime)
	print(P1Glob.can_combo)
	print("was it me uwu")

func attack_combo_1_1(damage_outgoing: float):
	$Timer.stop()
	animator.play("attack_combo_1_1")
	P1Glob.attacking = true
	P1Glob.can_combo = true 
	while animator.frame < 5 and animator.is_playing():
		await animator.frame_changed 
	if (!animator.is_playing() and P1Glob.state == possible_states.p1attacking):
		breakpoint
	if combo_1_1kicker.is_colliding() and P1Glob.state == possible_states.p1attacking:
		combo_1_1kicker.get_collider().hurt(damage_outgoing)
	await animator.animation_finished
	$Timer.start(standardcombotime)
	print(P1Glob.state)

func _on_timer_timeout():
	P1Glob.can_combo = false
	print("can't combo")

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2
	if P1Glob.state == possible_states.p1dead:
		return
	P1Glob.state_check()
	if P1Glob.state == possible_states.p1idle:
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("selfhurt") and !Input.is_action_just_pressed("selfhurt_big"):
			taken_damage(1)
		if Input.is_action_just_pressed("selfhurt_big"):
			taken_damage(3.34)
		if Input.is_action_just_pressed("light"):
			if P1Glob.can_combo:
				P1Glob.combo_state_check()
				if P1Glob.combo_state == "attack_combo_1_1":
					attack_combo_1_1(6.67)
			else:
				attack(3.34)
		if Input.is_action_just_pressed("guard"):
			guard()

	if P1Glob.guarding and !Input.is_action_pressed("guard"):
		P1Glob.guarding = false
		block_reduction = 1
	P1Glob.state_check()
	var direction = Input.get_axis("left", "right")
	if P1Glob.state == possible_states.p1idle and !animator.is_playing():
		animator.play("idle")
	if direction and P1Glob.state == possible_states.p1idle:
		velocity.x = direction * SPEED
		print(P1Glob.state)
		print("my bad")
		animator.play("walk")
	if !direction or (P1Glob.state != possible_states.p1idle and is_on_floor()):
		velocity.x = move_toward(velocity.x, 0, SPEED)


	move_and_slide()
	
	# temp for testing sprites
	if $AnimatedSprite2D.get_animation() == "idle":
		pass
		$AnimatedSprite2D.scale = Vector2(1,1)
	else:
		$AnimatedSprite2D.scale = Vector2(0.18,0.18)
	
	#combo input direction detection state machine
	

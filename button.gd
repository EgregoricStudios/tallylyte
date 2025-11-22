extends Button
#credit Zylann on Godot forums for wisdom on changing scenes

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_button_pressed) #allows _button_pressed() to function

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass #if you delete this the world will end

func _button_pressed():
	print("Hello, world!")
	$Label.visible = true
	await get_tree().create_timer(1.0).timeout
	$Label.visible = false
	get_tree().change_scene_to_file("res://testcell.tscn")

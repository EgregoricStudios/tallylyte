# Saved as a file named 'character.gd'.

class_name Character


var health = 5


func print_health():
	print(health)


func print_this_script_three_times():
	print(get_script())
	print(ResourceLoader.load("res://character.gd"))
	print(Character)

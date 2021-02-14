extends Node2D

class_name Elevator

var direction: String # west, east

func _ready():
	for f in range(1, 10):
		$buttons.find_node(str(f)).connect("pressed", Main, "goto_floor", [f, self.direction])

extends Node2D

var frame: int = 0

func _ready():
	$start.connect("mouse_entered", self, "highlight")
	$start.connect("mouse_exited", self, "lowlight")
	$start.connect("pressed", Main, "start")
	
func highlight():
	$start/start.get_font("font").outline_size = 5
	
func lowlight():
	$start/start.get_font("font").outline_size = 1

func _process(delta):
	frame += 1
	
	if frame % 3 == 0:
		if $"title-signal".frame == 3:
			Main.audio.play("signal-short")
		$"title-signal".frame = ($"title-signal".frame % ($"title-signal".hframes - 1)) + 1

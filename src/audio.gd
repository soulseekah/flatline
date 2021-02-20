extends Node2D

class_name Audio

var streams: Dictionary = {}

var frames: int = 0

func play(sound, loop = false, volume = -1.0):
	var player = AudioStreamPlayer.new()
	player.stream = load("res://assets/%s.ogg" % sound)
	player.volume_db = volume
	player.stream.loop = loop
	player.play()
	self.add_child(player)

func _process(delta):
	self.frames += 1
	
	if self.frames % 500 == 0:
		if randf() < 0.3:
			self.play("ann-%d" % rand_range(1.0, 7.9), false, 3.0)

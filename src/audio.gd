extends Node2D

class_name Audio

var streams: Dictionary = {}

var frames: int = 0
var announcing: int = 0
var last: int = 0

func play(sound, loop = false, volume = -1.0, bus = "Master"):
	var player = AudioStreamPlayer.new()
	player.stream = load("res://assets/%s.ogg" % sound)
	player.stream.loop = loop
	player.volume_db = volume
	player.bus = bus
	player.play()
	self.add_child(player)

func _process(delta):
	self.frames += 1
	
	if (self.frames % 300) == 0 and (self.announcing + 10 < Main.time):
		if randf() < 0.3:
			self.announcing = Main.time
			
			var cue = 1
			while true:
				cue = int(rand_range(1.0, 14.9))
				if cue != self.last:
					break
			self.play("ann-%d" % cue, false, 3.0, "speakers")

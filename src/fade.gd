extends Node2D

class_name Fade

var queue: Array = []
var current: float = 0.0
var done: bool = true

func _process(delta):
	if not self.queue.size() and self.current == 0.0:
		self.done = true
		return
	self.done = false
	if self.current == 0.0:
		self.current = self.queue.pop_front()
	$fade.color.a += self.current
	$fade.color.a = clamp($fade.color.a, 0.0, 1.0)
	if $fade.color.a in [0.0, 1.0]:
		self.current = 0.0

func in(impulse: float):
	self.queue.append(-impulse)

func out(impulse: float):
	self.queue.append(impulse)

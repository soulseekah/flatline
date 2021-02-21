extends Node2D

class_name Pager

onready var slide_in: Animation = Animation.new()
onready var slide_out: Animation = Animation.new()

onready var animation: AnimationPlayer = AnimationPlayer.new()

var messages: Array = []
var unqueues: Array = []
var skipping: bool = false

func _ready():
	add_child(self.animation)
	
	self.slide_in.loop = false
	var position = self.slide_in.add_track(Animation.TYPE_VALUE)
	self.slide_in.track_set_path(position, "%s:position:x" % self.get_path())
	self.slide_in.track_insert_key(position, 0.0, 1500)
	self.slide_in.track_insert_key(position, 1.0, 500)
	self.slide_in.set_length(1.0)
	self.animation.add_animation("slide-in", self.slide_in)
	
	self.slide_out.loop = false
	position = self.slide_out.add_track(Animation.TYPE_VALUE)
	self.slide_out.track_set_path(position, "%s:position:x" % self.get_path())
	self.slide_out.track_insert_key(position, 0.0, 500)
	self.slide_out.track_insert_key(position, 1.0, 1500)
	self.slide_out.set_length(1.0)
	self.animation.add_animation("slide-out", self.slide_out)
	
func send_message(message):
	Main.audio.play("beeper")
	self.skipping = false
	
	var type = Animation.new()
	type.loop = false
	var visible_characters = type.add_track(Animation.TYPE_VALUE)
	type.track_set_path(visible_characters, "%s/message:visible_characters" % self.get_path())
	type.track_insert_key(visible_characters, 0.0, 0)
	type.track_insert_key(visible_characters, 1.0, 0)
	type.track_insert_key(visible_characters, 1.0 + len(message) * 0.1, len(message))
	type.track_insert_key(visible_characters, 1.0 + len(message) * 0.1 + 5.0, len(message))
	type.set_length(1.0 + len(message) * 0.1 + 5.0)
	self.animation.add_animation("type", type)
	
	$message.visible_characters = 0
	$message.text = "\n%s" % message.to_upper()
	
	self.animation.queue("slide-in")
	self.animation.queue("type")
	self.animation.queue("slide-out")

func queue_message(time, message, group = -1):
	for m in messages:
		if m[1] == message:
			return
	self.messages.append([time, message, group])

func unqueue_group(group):
	self.unqueues.append(group)
	
func skip():
	if not self.animation.is_playing() or self.skipping:
		return
	self.skipping = true
	self.animation.stop()
	self.animation.clear_queue()
	self.animation.queue("slide-out")

func _process(delta):
	for i in range(self.messages.size()):
		if self.animation.is_playing():
			break

		if self.messages[i][2] in self.unqueues:
			self.messages.remove(i)
			break
		
		if self.messages[i][0] < Main.time:
			self.send_message(self.messages[i][1])
			self.messages.remove(i)
			break
	self.animation.advance(delta)

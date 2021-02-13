extends Node2D

class_name Floor

var doors: Node2D
var level: int
var room: int

var doctor: Doctor

func set_doctor(doctor: Doctor, room: int):
	self.level = room / 100 # set floor number
	
	var Door: PackedScene = preload("res://objects/door.tscn")
	
	self.doors = Node2D.new()
	
	for i in range(0, 11):
		var door = Door.instance()
		if i in [0, 10]:
			door.find_node("number").text = "lift"
		else:
			door.find_node("number").text = "%d%02d" % [self.level, i]
		door.position.y = 240
		door.position.x = i * 240
		self.doors.add_child(door)
	
	# center on door number
	self.doors.position.x += 64 + 16 + 240 - (240 * (room % 10))
	self.add_child(doors)
	
	self.doctor = doctor
	self.doctor.position.x = 640 / 2
	self.doctor.position.y = 320

	self.add_child(self.doctor)

func _get_door_index():
	var d = 0 # Door number
	for door in self.doors.get_children():
		var width = door.find_node("door").get_size().x
		if self.doctor.position.x > (door.global_position.x - (width / 2)) and self.doctor.position.x < (door.global_position.x + (width / 2)):
			break
		d += 1
	return clamp(d, 0, self.doors.get_child_count() - 1)
	
func previous_door():
	self.room = clamp(self._get_door_index() - 1, 0, self.doors.get_child_count() - 1)
	return self._scroll_into_view(self.doors.get_child(self.room))
	
func next_door():
	self.room = clamp(self._get_door_index() + 1, 0, self.doors.get_child_count() - 1)
	return self._scroll_into_view(self.doors.get_child(self.room))
	
func _scroll_into_view(door: Node2D):
	if (door.position.x > 200 and door.position.x < 2300):
		if (door.global_position.x != 320):
			self.doors.position.x += 320 - door.global_position.x
	return door

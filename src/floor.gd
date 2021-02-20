extends Node2D

class_name Floor

var numbers: Array = []
var level: int
var room: int

var doctor: Doctor

const DOCTOR_SLOT_RIGHT = 560
const DOCTOR_SLOT_LEFT = 80
const DOCTOR_SLOT_MID = 300

func set_doctor(doctor: Doctor, room: int):
	self.level = room / 100 # set floor number
	self.room = room % 100
	
	for i in range(0, 3): # create numbers
		var number = $number.duplicate()
		numbers.append(number)
		
		var position = $number.get_rect().position
		position.x += i * 224
		number.set_position(position)
		
		number.hide()
		self.add_child(number)
	$number.hide()
	
	self.doctor = doctor
	self.doctor.position.y = 260
	
	self._scroll_into_view()

	self.add_child(self.doctor)

func previous_door():
	self.room = clamp(self.room - 1, 0, 10)
	self._scroll_into_view()
	
func next_door():
	self.room = clamp(self.room + 1, 0, 10)
	self._scroll_into_view()
	
func _scroll_into_view():
	self.numbers[0].show()
	self.numbers[1].show()
	self.numbers[2].show()
	
	if self.room == 0:
		$corridor.position.x = 0
		self.doctor.position.x = self.DOCTOR_SLOT_LEFT
		self.numbers[0].hide()
		self.numbers[1].text = '%d%02d' % [self.level, self.room + 1]
		self.numbers[2].text = '%d%02d' % [self.level, self.room + 2]
	elif self.room == 10:
		$corridor.position.x = -1280
		self.doctor.position.x = self.DOCTOR_SLOT_RIGHT
		self.numbers[0].text = '%d%02d' % [self.level, self.room - 2]
		self.numbers[1].text = '%d%02d' % [self.level, self.room - 1]
		self.numbers[2].hide()
	else:
		if self.room < 2:
			$corridor.position.x = 0
			self.numbers[0].hide()
		elif self.room > 8:
			$corridor.position.x = -1280
			self.numbers[2].hide()
		else:
			$corridor.position.x = -640
		self.numbers[0].text = '%d%02d' % [self.level, self.room - 1]
		self.numbers[1].text = '%d%02d' % [self.level, self.room]
		self.numbers[2].text = '%d%02d' % [self.level, self.room + 1]
		self.doctor.position.x = self.DOCTOR_SLOT_MID

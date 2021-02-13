extends Node2D

class_name Room

var beds: Array
var doctor: Doctor

var number: int

func set_beds(beds: Array):
	self.beds = beds
	
	var x: int = 64
	for bed in self.beds:
		bed.position.y = 160
		bed.position.x = x
		self.add_child(bed)
		x += 123

func set_doctor(doctor: Doctor):
	self.doctor = doctor
	self.doctor.position.x = self.beds[2].position.x
	self.doctor.position.y = 320
	self.add_child(self.doctor)

# Returns the bed facing the doctor
func _get_bed_index():
	var b = 0 # Bed number
	for bed in self.beds:
		var width = bed.find_node("bed").get_size().x
		if self.doctor.position.x > (bed.position.x - (width / 2)) and self.doctor.position.x < (bed.position.x + (width / 2)):
			break
		b += 1
	return clamp(b, 0, len(self.beds) - 1)

func next_bed():
	return self.beds[clamp(self._get_bed_index() + 1, 0, len(self.beds) - 1)]

func previous_bed():
	return self.beds[clamp(self._get_bed_index() - 1, 0, len(self.beds) - 1)]

# Enter monitor mode maybe
func select_bed():
	print(self._get_bed_index())

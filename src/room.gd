extends Node2D

class_name Room

func set_beds(beds: Array):
	var x: int = 64
	for bed in beds:
		bed.position.y = 160
		bed.position.x = x
		self.add_child(bed)
		x += 123

func set_doctor(doctor: Doctor):
	doctor.position.x = 312
	doctor.position.y = 320
	self.add_child(doctor)

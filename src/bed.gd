extends Node2D

var patient: Patient

func set_patient(patient: Patient):
	self.patient = patient
	$patient.visible = true if self.patient else false

func _ready():
	pass

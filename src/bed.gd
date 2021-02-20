extends Node2D

var patient: Patient

func set_patient(patient: Patient):
	self.patient = patient
	$patient.visible = true if self.patient else false

func _ready():
	pass

func _process(delta):
	if self.patient and self.patient.connected:
		$monitor_on.show()
		$monitor_off.hide()

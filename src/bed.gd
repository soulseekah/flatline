extends Node2D

var patient: int = -1

func set_patient(patient: int):
	self.patient = patient
	$patient.visible = false if patient < 0 else true

func _process(delta):
	if self.patient > -1 and Main.patients[self.patient].connected:
		$monitor_on.show()
		$monitor_off.hide()
	
	if Main.patients[self.patient].dead or Main.patients[self.patient].done:
		$patient.visible = false

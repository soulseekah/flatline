extends Node2D

var patient: Patient
var frames: int = 0

func _ready():
	$connect.connect("pressed", Main, "connect_patient", [self.patient])

func set_patient(patient: Patient):
	self.patient = patient

func _process(delta):
	frames += 1
	
	if self.patient and self.patient.connected:
		$connect.modulate = Color(0.196078,0.196078,0.196078,1)
		
		$beta.modulate = Color(1, 1, 1, 1)
		$sympathomimetics.modulate = Color(1, 1, 1, 1)
		$cpr.modulate = Color(1, 1, 1, 1)
		$difibrillate.modulate = Color(1, 1, 1, 1)
		
		$hr.modulate = Color(1, 1, 1, 1)
		$hr/bpm.modulate = Color(1, 1, 1, 1)
		$hr/signal.modulate = Color(1, 1, 1, 1)
		$bp.modulate = Color(1, 1, 1, 1)
		$bp/sys.modulate = Color(1, 1, 1, 1)
		$bp/dia.modulate = Color(1, 1, 1, 1)
		
		$name.modulate = Color(1, 1, 1, 1)
		
		$name.text = "%s (%s, %d)" % [self.patient._name, self.patient.gender, self.patient.age]
		$connect.disabled = true
		
		$hr/bpm.text = "%03d BPM" % self.patient.hr
		$bp/sys.text = "%03d mm/Hg sys" % self.patient.sys
		$bp/dia.text = "%03d mm/Hg dia" % self.patient.dia
		
		if frames % 6 == 0:
			$hr/signal.frame = ($hr/signal.frame + 1) % $hr/signal.hframes
	else:
		$name.text = "disconnected"
		if self.patient:
			$connect.modulate = Color(1, 1, 1, 1)
			$connect.disabled = false
		
		$hr/bpm.text = "--- BPM"
		$bp/sys.text = "--- mm/Hg sys"
		$bp/dia.text = "--- mm/Hg dia"

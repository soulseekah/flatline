extends Node2D

var patient: int = -1
var frames: int = 0

func _ready():
	$connect.connect("pressed", Main, "connect_patient", [self.patient])
	$beta.connect("pressed", self, "betalize")
	$sympathomimetics.connect("pressed", self, "sympath")
	$cpr.connect("pressed", self, "cpr")
	$defibrillate.connect("pressed", self, "defib")

func set_patient(patient: int):
	self.patient = patient

func _process(delta):
	frames += 1
	
	var patient = Main.patients[self.patient] if self.patient >= 0 else null
	
	if patient and patient.connected and not patient.dead:
		$connect.modulate = Color(0.196078,0.196078,0.196078,1)
		
		$beta.modulate = Color(1, 1, 1, 1)
		$beta.disabled = false
		$sympathomimetics.modulate = Color(1, 1, 1, 1)
		$sympathomimetics.disabled = false
		$cpr.modulate = Color(1, 1, 1, 1)
		$cpr.disabled = false
		$defibrillate.modulate = Color(1, 1, 1, 1)
		$defibrillate.disabled = false
		
		$hr.modulate = Color(1, 1, 1, 1)
		$hr/bpm.modulate = Color(1, 1, 1, 1)
		$hr/signal.modulate = Color(1, 1, 1, 1)
		$bp.modulate = Color(1, 1, 1, 1)
		$bp/sys.modulate = Color(1, 1, 1, 1)
		$bp/dia.modulate = Color(1, 1, 1, 1)
		
		$name.modulate = Color(1, 1, 1, 1)
		
		$name.text = "%s (%s, %d)" % [patient._name, patient.gender, patient.age]
		$connect.disabled = true
		
		$hr/bpm.text = "%03d BPM" % patient.hr
		$bp/sys.text = "%03d mm/Hg sys" % patient.sys
		$bp/dia.text = "%03d mm/Hg dia" % patient.dia
		
		if frames % 6 == 0:
			$hr/signal.frame = ($hr/signal.frame + 1) % $hr/signal.hframes

		if frames % int(0.5 * (200 - patient.hr)) == 0:
			Main.audio.play("signal-short", false, -10.0)
	else:
		$name.text = "disconnected"
		if patient:
			$connect.modulate = Color(1, 1, 1, 1)
			$connect.disabled = false
		
		$hr/bpm.text = "--- BPM"
		$bp/sys.text = "--- mm/Hg sys"
		$bp/dia.text = "--- mm/Hg dia"
		
		$beta.disabled = true
		$sympathomimetics.disabled = true
		$cpr.disabled = true
		$defibrillate.disabled = false

func betalize():
	Main.patients[self.patient].medication += 2.5

func sympath():
	Main.patients[self.patient].medication -= 2.5

func cpr():
	Main.patients[self.patient].cpr()
	
func defib():
	Main.patients[self.patient].defib()

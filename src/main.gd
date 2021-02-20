extends Node

var patients: Array = []
var beds: Dictionary = {}

var doctor: Doctor
var room: Room
var level: Floor
var status: Status
var pager: Pager

var audio: Audio

var can_move: bool

var time: float = 0.0

var difficulty: int = 0

func _ready():
	randomize()
	
	var Status: PackedScene = preload("res://ui/status.tscn")
	self.status = Status.instance()
	self.status.z_index = 1
	self.call_deferred("add_child", self.status)
	
	var Pager: PackedScene = preload("res://ui/pager.tscn")
	self.pager = Pager.instance()
	self.pager.z_index = 1
	self.pager.position.x = 1500 # offscreen
	self.pager.position.y = 380
	
	self.pager.queue_message(3, "Good morning, Dr. Flatline :) Welcome to your shift!")
	self.pager.queue_message(6, "Move using WASD or arrow keys.")
	self.pager.queue_message(9, "Go save your first patient in room 606... That's six-zero-six!")
	
	self.call_deferred("add_child", self.pager)
	
	var Audio: PackedScene = preload("res://misc/audio.tscn")
	self.audio = Audio.instance()
	self.audio.play("background", true, -15.0)
	self.call_deferred("add_child", self.audio)
	
	# Create beds in our hospital
	for f in range(1, 10):
		for r in range(1, 10):
			for b in range(0, 5):
				self.beds["%d%02d:%d" % [f, r, b]] = {
					"patient": -1
				}
	
	# Tutorial patient, unsavable :)
	var patient = Patient.new()
	patient._name = "Test Dummy"
	patient.gender = "male"
	patient.age = 35
	patient.health = 90
	self.patients.insert(patient.id, patient)
	self.beds["606:4"]['patient'] = patient.id
	
	self.call_deferred("remove_child", get_node("Title"))
	
	self._enter_level(100)
	
func _enter_level(number: int):
	var Doctor: PackedScene = preload("res://objects/doctor.tscn")
	self.doctor = Doctor.instance()
	
	var Floor: PackedScene = preload("res://scenes/floor.tscn")	
	self.level = Floor.instance()
	
	self.level.set_doctor(self.doctor, number)
	
	self.call_deferred("remove_child", get_node("Floor"))
	self.call_deferred("remove_child", get_node("Room"))
	self.call_deferred("add_child", self.level)
	
	self.room = null
	self.can_move = true

func _process(delta):
	self.time += delta
	for patient in self.patients:
		if not patient.dead and not patient.done:
			patient._process(delta)
			if patient.health < 30 and (patient.hr < 50 or patient.hr > 90):
				for bed in self.beds.keys():
					if self.beds[bed].patient == patient.id:
						self.pager.queue_message(0, "Patient is in critical condition. Room %s stat!!11!1!!!" % bed.substr(0, 3), patient.id)
			
	if self.difficulty > 0:
		# Start generating patients
		if randi() % (10 * (100 - self.difficulty)) == 0:
			var patient = Patient.new()
			self.patients.insert(patient.id, patient)
			var beds = self.beds.keys()
			beds.shuffle()
			for bed in beds:
				if self.beds[bed].patient == -1:
					self.beds[bed]['patient'] = patient.id
					self.pager.queue_message(0, "%s admitted into room %s" % [patient._name, bed.substr(0, 3)], patient.id)
					break

func _input(e):
	if Input.is_action_just_pressed("down") and get_node("Room/Monitor"):
		self.can_move = true
		self.room.remove_child(get_node("Room/Monitor"))
		return
		
	if Input.is_action_just_pressed("down") and get_node("Elevator"):
		self.can_move = true
		self.remove_child(get_node("Elevator"))
		return
	
	if not self.can_move:
		return
	
	if self.room: # We are in room mode
		if Input.is_action_just_pressed("left"):
			self.doctor.position.x = self.room.previous_bed().position.x
		
		if Input.is_action_just_pressed("right"):
			self.doctor.position.x = self.room.next_bed().position.x
			
		if Input.is_action_just_pressed("up"):
			self.room.select_bed()
			
		if Input.is_action_just_pressed("down"):
			self._enter_level(self.room.number)
	
	if self.level:
		if Input.is_action_just_pressed("left"):
			self.level.previous_door()
			
		if Input.is_action_just_pressed("right"):
			self.level.next_door()
			
		if Input.is_action_just_pressed("up"):
			if self.level.room in [0, 10]:
				var Elevator: PackedScene = preload("res://ui/elevator.tscn")
				var elevator = Elevator.instance()
				elevator.find_node("number").text = str(self.level.level)
				elevator.position.x = 220
				elevator.position.y = 275
				elevator.direction = "east" if self.level.room == 10 else "west"
				
				self.call_deferred("add_child", elevator)
				
				self.can_move = false
			else:
				var Doctor: PackedScene = preload("res://objects/doctor.tscn")
				self.doctor = Doctor.instance()
	
				var Room: PackedScene = preload("res://scenes/room.tscn")
				
				if self.difficulty == 0 and ((self.level.level * 100) + self.level.room == 606):
					self.pager.queue_message(12, "Approach the patient, use the monitor and connect them up. Stat.")
				
				self.room = Room.instance()
				self.room.set_number((self.level.level * 100) + self.level.room)
				self.room.set_beds()
				self.room.set_doctor(doctor)
				
				self.call_deferred("remove_child", get_node("Floor"))
				self.call_deferred("add_child", self.room)
				
				self.can_move = true
			
				self.level = null

func goto_floor(number, direction):
	self.call_deferred("remove_child", get_node("Elevator"))
	self._enter_level((number * 100) + (0 if direction == "west" else 10))

func connect_patient(patient):
	if patient == 0:
		self.pager.queue_message(15, "Beta blockers slow heart rate down. Sympathomimetics speed it up.")
		self.pager.queue_message(18, "Use CPR on stopped hearts. And defibrillation on hearts that need a reboot.")
		self.pager.queue_message(21, "Keep the hearts pumping at 70 bpm.")
		self.pager.queue_message(24, "Administering the right medications or procedures saves lives.")
	self.patients[patient].connected = true

func die(patient):
	if patient == 0:
		self.difficulty = 1
		
	self.patients[patient].connected = false
	for bed in beds.keys():
		if beds[bed].patient == patient:
			beds[bed].patient = -1
			break
	
	var flattery = ["Good job", "Great work", "Kudos", "Congratulations", "You're the best"]
	flattery.shuffle()
	self.pager.queue_message(0, "%s passed away, doc.\n%s!\n:)" % [self.patients[patient]._name, flattery.front()])
	self.pager.unqueue_group(patient)
	
	self.audio.play("signal", false, -5.0)

func checkout(patient):
	if patient == 0:
		self.difficulty = 1
		
	self.patients[patient].connected = false
	for bed in beds.keys():
		if beds[bed].patient == patient:
			beds[bed].patient = -1
			break
	self.pager.queue_message(0, "%s has checked out, doc." % [self.patients[patient]._name])
	self.pager.unqueue_group(patient)

extends Node

var patients: Array = []
var beds: Dictionary = {}

var doctor: Doctor
var room: Room
var level: Floor

var can_move: bool

func _ready():
	randomize()
	
	# Create beds in our hospital
	for f in range(1, 10):
		for r in range(1, 10):
			for b in range(0, 5):
				var patient = Patient.new() if randf() > 0.5 else null
				if patient:
					patients.append(patient)
				self.beds["%d%02d:%d" % [f, r, b]] = {
					"patient": patient
				}
	
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
	return
	
func _input(e):
	if get_node("Room/Monitor") and Input.is_action_just_pressed("down"):
		self.can_move = true
		self.room.remove_child(get_node("Room/Monitor"))
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
			self.doctor.position.x = self.level.previous_door().global_position.x
			
		if Input.is_action_just_pressed("right"):
			self.doctor.position.x = self.level.next_door().global_position.x
			
		if Input.is_action_just_pressed("up"):
			if self.level.room in [0, 10]:
				var Elevator: PackedScene = preload("res://ui/elevator.tscn")
				var elevator = Elevator.instance()
				elevator.find_node("number").text = str(self.level.level)
				elevator.position.x = 320
				elevator.position.y = 240
				elevator.direction = "east" if self.level.room == 10 else "west"
				
				self.call_deferred("add_child", elevator)
				
				self.can_move = false
			else:
				var Doctor: PackedScene = preload("res://objects/doctor.tscn")
				self.doctor = Doctor.instance()
	
				var Room: PackedScene = preload("res://scenes/room.tscn")
				
				self.room = Room.instance()
				self.room.number = (self.level.level * 100) + self.level.room
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
	
	self.patients[patient.id].connected = true

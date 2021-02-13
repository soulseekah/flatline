extends Node

var patients: Array = []

var doctor: Doctor
var room: Room
var level: Floor

func _ready():
	var Room: PackedScene = preload("res://scenes/room.tscn")
	var Bed: PackedScene = preload("res://objects/bed.tscn")
	var Doctor: PackedScene = preload("res://objects/doctor.tscn")
	
	self.room = Room.instance()
	self.room.number = 205
	self.doctor = Doctor.instance()
	
	self.room.set_beds([Bed.instance(), Bed.instance(), Bed.instance(), Bed.instance(), Bed.instance()])
	self.room.set_doctor(doctor)
	
	self.call_deferred("remove_child", get_tree().get_root().get_child(1))
	self.call_deferred("add_child", self.room)

func _process(delta):
	return
	
func _input(e):
	if self.room: # We are in room mode
		if Input.is_action_just_pressed("left"):
			self.doctor.position.x = self.room.previous_bed().position.x
		
		if Input.is_action_just_pressed("right"):
			self.doctor.position.x = self.room.next_bed().position.x
			
		if Input.is_action_just_pressed("up"):
			self.room.select_bed()
			
		if Input.is_action_just_pressed("down"):
			var Floor: PackedScene = preload("res://scenes/floor.tscn")
			var Doctor: PackedScene = preload("res://objects/doctor.tscn")
			
			self.level = Floor.instance()
			self.doctor = Doctor.instance()
			
			self.level.set_doctor(self.doctor, self.room.number)
			
			self.call_deferred("remove_child", get_child(0))
			self.call_deferred("add_child", self.level)
			
			self.room = null
	
	if self.level:
		if Input.is_action_just_pressed("left"):
			self.doctor.position.x = self.level.previous_door().global_position.x
			
		if Input.is_action_just_pressed("right"):
			self.doctor.position.x = self.level.next_door().global_position.x
			
		if Input.is_action_just_pressed("up"):
			if self.level.room in [0, 10]:
				print("elevator ding")
			else:
				var Room: PackedScene = preload("res://scenes/room.tscn")
				var Doctor: PackedScene = preload("res://objects/doctor.tscn")
				var Bed: PackedScene = preload("res://objects/bed.tscn")
				
				self.room = Room.instance()
				self.room.number = (self.level.level * 100) + self.level.room
				self.doctor = Doctor.instance()
				
				self.room.set_beds([Bed.instance(), Bed.instance(), Bed.instance(), Bed.instance(), Bed.instance()])
				self.room.set_doctor(doctor)
				
				self.call_deferred("remove_child", get_child(0))
				self.call_deferred("add_child", self.room)
			
				self.level = null

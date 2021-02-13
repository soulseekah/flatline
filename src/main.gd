extends Node

var patients: Array = []

var doctor: Doctor

func _ready():
	var Room: PackedScene = preload("res://scenes/room.tscn")
	var Bed: PackedScene = preload("res://objects/bed.tscn")
	var Doctor: PackedScene = preload("res://objects/doctor.tscn")
	
	var room: Node2D = Room.instance()
	doctor = Doctor.instance()
	
	room.set_beds([Bed.instance(), Bed.instance(), Bed.instance(), Bed.instance(), Bed.instance()])
	room.set_doctor(doctor)
	
	self.call_deferred("remove_child", get_tree().get_root().get_child(1))
	self.call_deferred("add_child", room)

func _process(delta):
	return
	
func _input(e):
	if Input.is_action_just_released("left"):
		doctor.position.x -= 123
	
	if Input.is_action_just_released("right"):
		doctor.position.x += 123

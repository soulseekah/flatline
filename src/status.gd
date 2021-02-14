extends Node2D

class_name Status

func _process(delta):
	$bar/location.text = '%d%s floor' % [Main.level.level, {
		1: 'st', 2: 'nd', 3: 'rd'
	}.get(Main.level.level, 'th')] if Main.level else 'Room %d' % Main.room.number

	$bar/stats.text = '%d checked out, %d dead, %d total patients' % [0, 0, len(Main.patients)]

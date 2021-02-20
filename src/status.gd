extends Node2D

class_name Status

func _process(delta):
	$bar/location.text = '%d%s floor' % [Main.level.level, {
		1: 'st', 2: 'nd', 3: 'rd'
	}.get(Main.level.level, 'th')] if Main.level else 'Room %d' % Main.room.number

	var counts = {
		'done': 0,
		'dead': 0,
		'total': 0,
	}
	
	for patient in Main.patients:
		if patient.done:
			counts['done'] += 1
		if patient.dead:
			counts['dead'] += 1
		counts['total'] += 1
	
	$bar/stats.text = '%d checked out, %d dead\n%d total patients' % [counts.done, counts.dead, counts.total]

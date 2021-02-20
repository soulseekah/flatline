extends Node

class_name Patient

var connected = false
var health: float = 50.0
var id: int = 0

var hr: float = 120.0
var sys: int = 120
var dia: int = 80 

var age: int = 31
var _name = ""
var gender = "female"

var direction: float = 0.0
var medication: float = 0.0

var dead = false
var done = false

var time: float = 0.0

func _init():
	self.health = 40 + (randf() * 30)
	
	self.id = len(Main.patients)
	self.age = 14 + (randf() * 85)
	self.hr = 40 + (randf() * 150)
	self.gender = "female" if randi() % 2 else "male"
	self._name = self.generate_name()
	
func _process(delta):
	if self.health <= 0 and not self.dead:
		self.dead = true
		Main.die(self.id)
		return
	
	if self.health >= 100 and not self.done:
		self.done = true
		Main.checkout(self.id)
		return

	time += delta
	
	# Health deteriorates with time unless hr is ~70
	self.health -= (abs(70 - self.hr) - 20) * delta * 0.025
	if self.hr < 20 or self.hr > 170:
		self.health -= 5 * delta
	
	# HR changes with direction and medication
	self.hr -= self.direction * delta + (self.medication * delta)
	self.hr = clamp(self.hr, 0, 300)
	
	# Medication tapers off
	self.medication += -self.medication/100
	
	# Shit happens
	self.direction += -0.01 if randi() % 2 else 0.01
	
	# And dissolves
	# TODO: dissolve the shit that happened above
	# TODO: heal faster
	
	# self.sys = 120 * (1 - abs((70 - self.hr) / 100))
	# self.dia = 80 * (1 - abs((70 - self.hr) / 100))
	
	# print([self.id, self.hr, self.direction, self.medication, self.health])

func cpr():
	if self.hr > 5:
		self.hr += 1
		self.health -= 5
		return
	self.health -= 1
	self.direction -= randf() * 15.0
		
func defib():
	if self.hr < 200:
		self.hr = 0
		self.health -= 20
		return
	self.health -= 5
	self.hr = 40 + (randf() * 140)
	self.direction += randf() * 15.0

func generate_name():
	var males = ['James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Joseph', 'Thomas', 'Charles', 'Christopher', 'Daniel', 'Matthew', 'Anthony', 'Donald', 'Mark', 'Paul', 'Steven', 'Andrew', 'Kenneth', 'Joshua', 'Kevin', 'Brian', 'George', 'Edward', 'Ronald', 'Timothy', 'Jason', 'Jeffrey', 'Ryan', 'Jacob', 'Gary', 'Nicholas', 'Eric', 'Jonathan', 'Stephen', 'Larry', 'Justin', 'Scott', 'Brandon', 'Benjamin', 'Samuel', 'Frank', 'Gregory', 'Raymond', 'Alexander', 'Patrick', 'Jack', 'Dennis', 'Jerry', 'Tyler', 'Aaron', 'Jose', 'Henry', 'Adam', 'Douglas', 'Nathan', 'Peter', 'Zachary', 'Kyle', 'Walter', 'Harold', 'Jeremy', 'Ethan', 'Carl', 'Keith', 'Roger', 'Gerald', 'Christian', 'Terry', 'Sean', 'Arthur', 'Austin', 'Noah', 'Lawrence', 'Jesse', 'Joe', 'Bryan', 'Billy', 'Jordan', 'Albert', 'Dylan', 'Bruce', 'Willie', 'Gabriel', 'Alan', 'Juan', 'Logan', 'Wayne', 'Ralph', 'Roy', 'Eugene', 'Randy', 'Vincent', 'Russell', 'Louis', 'Philip', 'Bobby', 'Johnny', 'Bradley']
	var females = ['Mary', 'Patricia', 'Jennifer', 'Linda', 'Elizabeth', 'Barbara', 'Susan', 'Jessica', 'Sarah', 'Karen', 'Nancy', 'Lisa', 'Margaret', 'Betty', 'Sandra', 'Ashley', 'Dorothy', 'Kimberly', 'Emily', 'Donna', 'Michelle', 'Carol', 'Amanda', 'Melissa', 'Deborah', 'Stephanie', 'Rebecca', 'Laura', 'Sharon', 'Cynthia', 'Kathleen', 'Amy', 'Shirley', 'Angela', 'Helen', 'Anna', 'Brenda', 'Pamela', 'Nicole', 'Samantha', 'Katherine', 'Emma', 'Ruth', 'Christine', 'Catherine', 'Debra', 'Rachel', 'Carolyn', 'Janet', 'Virginia', 'Maria', 'Heather', 'Diane', 'Julie', 'Joyce', 'Victoria', 'Kelly', 'Christina', 'Lauren', 'Joan', 'Evelyn', 'Olivia', 'Judith', 'Megan', 'Cheryl', 'Martha', 'Andrea', 'Frances', 'Hannah', 'Jacqueline', 'Ann', 'Gloria', 'Jean', 'Kathryn', 'Alice', 'Teresa', 'Sara', 'Janice', 'Doris', 'Madison', 'Julia', 'Grace', 'Judy', 'Abigail', 'Marie', 'Denise', 'Beverly', 'Amber', 'Theresa', 'Marilyn', 'Danielle', 'Diana', 'Brittany', 'Natalie', 'Sophia', 'Rose', 'Isabella', 'Alexis', 'Kayla', 'Charlotte']
	var seconds = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker', 'Young', 'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores', 'Green', 'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell', 'Carter', 'Roberts']
	
	return PoolStringArray([
		males[randi() % len(males)] if self.gender == "male" else females[randi() % len(females)],
		seconds[randi() % len(seconds)]
	]).join(" ")

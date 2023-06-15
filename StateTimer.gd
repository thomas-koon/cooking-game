extends Timer

var MIN = 0.3  
var MAX = 0.5 

# Called when the node enters the scene tree for the first time.
func _ready():
	generateRandomInterval()

func generateRandomInterval():
	var randomInterval = rand_range(MIN, MAX)
	set_wait_time(randomInterval)
	start()

func timeout():
	generateRandomInterval()

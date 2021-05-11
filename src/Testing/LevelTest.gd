extends Spatial

onready var player = $Gridmap/Player
onready var enemy = $Gridmap/Enemy



func _ready():
	enemy.set_target(player)








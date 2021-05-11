extends Node


signal enemy_change_state

var enemy_state setget change_state 
var prev_enemy_state


var cell = []
var grid

# heuristic true is manhattan and false is euclidean
var heuristic = false

# path solution count
signal path_solution
var path_count setget change_path_solution


# open node count
signal open_node
var open_node_count setget change_open_node

# signal visited node
signal visited_node
var closed_node_count setget change_closed_node


#time usage
signal time_usage
var time_usage_count setget change_time_usage

#memory usage
signal memory_usage
var memory_usage_count setget change_memory_usage

#cost node
signal cost_node
var cost_node_count setget change_cost_node

#enemy update position
signal enemy_position_update
var enemy_pos setget change_enemy_position


func _ready():
	Engine.target_fps = 60


func get_neighbours(node):
	var neighbours = []
	
	var relative_nodes = PoolVector3Array([
			Vector3(node.tile_pos.x + 1, node.tile_pos.y, node.tile_pos.z), #right
			Vector3(node.tile_pos.x - 1, node.tile_pos.y, node.tile_pos.z), #left
			Vector3(node.tile_pos.x, node.tile_pos.y, node.tile_pos.z + 1), #bottom
			Vector3(node.tile_pos.x, node.tile_pos.y, node.tile_pos.z - 1), #up
			Vector3(node.tile_pos.x + 1, node.tile_pos.y ,node.tile_pos.z + 1), #right bottom
			Vector3(node.tile_pos.x - 1, node.tile_pos.y ,node.tile_pos.z - 1), #left up
			Vector3(node.tile_pos.x - 1, node.tile_pos.y ,node.tile_pos.z + 1), #left bottom
			Vector3(node.tile_pos.x + 1, node.tile_pos.y ,node.tile_pos.z - 1) # right up
		])
	
	for relative in relative_nodes:
		if cell.has(relative):
			neighbours.append(relative)
		
	return neighbours


func change_state(new_state):
	enemy_state = new_state
	emit_signal("enemy_change_state")


func change_path_solution(new_path):
	path_count = new_path
	emit_signal("path_solution")


func change_open_node(new_open_node):
	open_node_count = new_open_node
	emit_signal("open_node")


func change_time_usage(new_time_usage):
	time_usage_count = new_time_usage
	emit_signal("time_usage")


func change_memory_usage(new_memory_usage):
	memory_usage_count = new_memory_usage
	emit_signal("memory_usage")


func change_enemy_position(new_enemy_pos):
	enemy_pos = new_enemy_pos 
	emit_signal("enemy_position_update")


func change_closed_node(new_closed_node):
	closed_node_count = new_closed_node
	emit_signal("visited_node")
	
func change_cost_node(new_cost_node):
	cost_node_count = new_cost_node
	emit_signal("cost_node")

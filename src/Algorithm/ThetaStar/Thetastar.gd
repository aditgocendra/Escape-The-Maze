extends Node
class_name ThetaStar

var gridmap: GridMap
var nav_id 
var utils


var open_list
var closed_list

var start_node
var end_node

var time_before
var memory_before


func _init(gridmap, nav_id):
	self.gridmap = gridmap
	self.nav_id = nav_id
	Autoload.cell = set_nav_tiles()
	utils = Utility.new()
	


func find_path(start_index, end_index):
	time_before = OS.get_ticks_msec()
	memory_before = OS.get_static_memory_usage()
	
	start_node = ThetaNode.new()
	end_node = ThetaNode.new()
	
	start_node.tile_pos = start_index
	end_node.tile_pos = end_index
	
	start_node.parent = start_node
	end_node.parent = null
	
	open_list = []
	closed_list = []
	
	open_list.append(start_node)
	
	var current_node
	
	while(open_list.size() > 0):
		current_node = open_list[0]
		var current_index = 0 
		
		#search best node
		var index = 0
		for index_item in open_list:
			
			if index_item.f < current_node.f:
				current_node = index_item
				current_index = index
			index += 1
		
		
		open_list.remove(current_index)
		closed_list.append(current_node)
		
		
		if current_node.tile_pos == end_node.tile_pos:
			var path = []
			var current = current_node
			
			var cost_node = 0
			while current.parent.tile_pos != current.tile_pos:
				path.push_front(current.tile_pos)
				cost_node += current.f
				current = current.parent
			path.push_front(current.tile_pos)
			
			var result = []
			for point in path:
				var point_map = gridmap.map_to_world(point.x , point.y, point.z)
				result.append(point_map)
			
			Autoload.path_count = result
			Autoload.open_node_count = open_list.size()
			Autoload.time_usage_count = (OS.get_ticks_msec() - time_before)
			Autoload.memory_usage_count = (OS.get_static_memory_usage() - memory_before)
			Autoload.closed_node_count = closed_list.size()
			Autoload.cost_node_count = cost_node
			return result
			
		#get childern node
		var childern = PoolVector3Array([
				Vector3(current_node.tile_pos.x + 1, current_node.tile_pos.y, current_node.tile_pos.z),
				Vector3(current_node.tile_pos.x - 1, current_node.tile_pos.y, current_node.tile_pos.z),
				Vector3(current_node.tile_pos.x, current_node.tile_pos.y, current_node.tile_pos.z + 1),
				Vector3(current_node.tile_pos.x, current_node.tile_pos.y, current_node.tile_pos.z - 1),
				Vector3(current_node.tile_pos.x + 1,current_node.tile_pos.y, current_node.tile_pos.z + 1),
				Vector3(current_node.tile_pos.x - 1,current_node.tile_pos.y, current_node.tile_pos.z - 1),
				Vector3(current_node.tile_pos.x - 1,current_node.tile_pos.y, current_node.tile_pos.z + 1),
				Vector3(current_node.tile_pos.x + 1,current_node.tile_pos.y, current_node.tile_pos.z - 1)
			])
		#get neighbour
		var neighbour = []
		for i in range(childern.size()):
			if Autoload.cell.has(childern[i]):
				var new_node = ThetaNode.new()
				new_node.tile_pos = childern[i]
				
				neighbour.append(new_node)
		
		for node_neighbour in neighbour:
			var visited = false
			
			for close_node in closed_list:
				if close_node.tile_pos == node_neighbour.tile_pos:
					visited = true
			
			for open_node in open_list:
				if open_node.tile_pos == node_neighbour.tile_pos:
					visited = true
				
			if visited == false:
				node_neighbour.g  = INF
				node_neighbour.parent = null
				update_vertex(current_node, node_neighbour)
				
				
func update_vertex(current, neigh):
	var gOld = neigh.g
	compute_cost(current, neigh)
	if neigh.g < gOld:
		var index = 0
		for open_node in open_list:
			if open_node.tile_pos == neigh.tile_pos:
				open_list.remove(index)
			index += 1
		if Autoload.heuristic:
			neigh.h = utils.manhattan(abs(neigh.tile_pos.x - end_node.tile_pos.x) , abs(neigh.tile_pos.z - end_node.tile_pos.z))
		else: neigh.h = utils.euclidean(neigh.tile_pos ,end_node.tile_pos)
		neigh.f = neigh.g + neigh.h
		
		open_list.append(neigh)


func compute_cost(current, neigh):
	#path 2
	if line_of_sight(current.parent, neigh):
		if Autoload.heuristic:
			if current.parent.g + utils.manhattan(abs(neigh.tile_pos.x - current.parent.tile_pos.x), abs(neigh.tile_pos.z - current.parent.tile_pos.z) ) < neigh.g:
				neigh.parent = current.parent 
				neigh.g = current.parent.g + utils.manhattan(abs(neigh.tile_pos.x - current.parent.tile_pos.x), abs(neigh.tile_pos.z - current.parent.tile_pos.z)) 
		else:
			if current.parent.g + utils.euclidean(current.parent.tile_pos, neigh.tile_pos) < neigh.g:
				neigh.parent = current.parent
				neigh.g = current.parent.g + utils.euclidean(current.parent.tile_pos, neigh.tile_pos) 
	else:
		#path 1
		if Autoload.heuristic:
			if current.g + utils.manhattan(abs(neigh.tile_pos.z - current.tile_pos.x), abs(neigh.tile_pos.z - current.tile_pos.z)) < neigh.g:
				neigh.parent = current
				neigh.g = current.parent.g + utils.manhattan(abs(neigh.tile_pos.x - current.tile_pos.x), abs(neigh.tile_pos.z - current.tile_pos.z)) 
		else:
			if current.g + utils.euclidean(current.tile_pos, neigh.tile_pos) < neigh.g:
				neigh.parent = current 
				neigh.g = current.g + utils.euclidean(current.tile_pos, neigh.tile_pos)
			
	
	
func line_of_sight(current, neighbour):
	var current_pos = gridmap.map_to_world(current.tile_pos.x, 0, current.tile_pos.z) 
	var neighbour_pos = gridmap.map_to_world(neighbour.tile_pos.x, 0, neighbour.tile_pos.z)
	
	var x0 = current_pos.x
	var z0 = current_pos.z
	var x1 = neighbour_pos.x
	var z1 = neighbour_pos.z
	
	var dz = z1 - z0
	var dx = x1 - x0
	
	var f = 0
	
	var sx = 0
	var sz = 0
	
	
	if dz < 0:
		dz = -dz
		sz = - 0.5
	else: sz = 0.5
	
	if dx < 0:
		dx = -dx
		sx = - 0.5
	else: sx = 0.5
	
	if dx >= dz:
		while x0 != x1:
			f = f + dz
			if f >= dx:
				if isBlocked(Vector3(x0 + sx , 0 ,z0 + sz)): 
					return false
				z0 = z0 + sz
				f = f - dx
			
			if f != 0 and isBlocked(Vector3(x0 + sx, 0, z0 + sz)):
				return false
			
			if dz == 0 and isBlocked(Vector3(x0 + sx, 0 ,z0)) and isBlocked(Vector3(x0 + sx, 0, z0 - 1)):
				return false
			
			x0 = x0 + sx
			
	else:
		while z0 != z1:
			f = f + dx
			
			if f >= dz:
				if isBlocked(Vector3(x0 + sx, 0, z0 + sz)):
					return false
				x0 = x0 + sx
				f = f - dz
			if f != 0 and isBlocked(Vector3(x0 + sx, 0, z0 + sz)):
				return false
			
			if dx == 0 and isBlocked(Vector3(x0 , 0, z0 + sz)) and isBlocked(Vector3(x0 - 1 , 0, z0 + sz)):
				return false
			z0 = z0  + sz
			
	return true
	
	
func isBlocked(vector):
	var map = gridmap.world_to_map(vector)
	
	if !Autoload.cell.has(map):
		return true


func set_nav_tiles():
	var result = []
	
	for cell in gridmap.get_used_cells():
		var id_object =  gridmap.get_cell_item(cell.x, cell.y, cell.z)
		if id_object == nav_id:
#			if cell != block_cell:
			result.append(Vector3(cell.x, cell.y, cell.z))
		
	return result

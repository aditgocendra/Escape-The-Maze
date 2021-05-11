extends Node
class_name JPS




var open_list
var closed_list

var utils 
var JPF

var gridmap: GridMap
var nav_id

var time_before
var memory_before

func _init(gridmap, nav_id):
	self.gridmap = gridmap
	self.nav_id = nav_id
	Autoload.cell = set_nav_tiles()
	
	
func find_path(start, end):
	time_before = OS.get_ticks_msec()
	memory_before = OS.get_static_memory_usage()
	
	JPF = JPFinder.new()
	utils = Utility.new()
	
	open_list = []
	closed_list = []
	#init node start and end node----
	var start_node = JumpNode.new()
	var end_node = JumpNode.new()
	start_node.tile_pos = start
	end_node.tile_pos = end
	
	start_node.gy = 0
	end_node.fy = 0
	#--------------------------------
	
	open_list.append(start_node)
	
	var current_node
	
	while (open_list.size() > 0):
		current_node = open_list.pop_front()
		closed_list.append(current_node)
		
		if current_node.tile_pos == end_node.tile_pos:
			var result = []
			var path = utils.backtrace(current_node)
#			print("Elapsed time: %dms"%(OS.get_ticks_msec() - time_before))
			for point in path:
				result.append(gridmap.map_to_world(point.x, point.y, point.z))
			
			Autoload.path_count = result
			Autoload.open_node_count = open_list.size()
			Autoload.time_usage_count = (OS.get_ticks_msec() - time_before)
			Autoload.memory_usage_count = (OS.get_static_memory_usage() - memory_before)
			Autoload.closed_node_count = closed_list.size()
			return result
			
		identify_succresors(current_node, start_node, end_node)
	
	print("not found")


func identify_succresors(current, start_node, end_node):
	var neighbours = JPF.find_neighbours(current)
#	var successor = []
#	print("Neighbours :" , neighbours)
	for index_neighbour in neighbours:
		var jumpPoint = JPF.jump(index_neighbour, current.tile_pos, end_node)
#		print("JumpPoint : ", jumpPoint)
		if jumpPoint:
			var jx = jumpPoint.x
			var jz = jumpPoint.z
			
			var jumpNode = JumpNode.new()
			jumpNode.tile_pos = Vector3(jx, jumpPoint.y , jz) 
			
			# check jump node in closed list
			var closed = false
			for close in closed_list:
				if close.tile_pos == jumpNode.tile_pos:
					closed = true
					break
			
			if closed:
				continue
			#------------------------------------------------------
			
			var d
			if Autoload.heuristic:
				d = utils.manhattan(abs(jx - current.tile_pos.x), abs(jz - current.tile_pos.z))
			else: d = utils.euclidean(jumpNode.tile_pos, current.tile_pos)
			var ng  = current.gy + d
			
			# check jump node in open list
			var opened = false
			
			for open in open_list:
				if open.tile_pos == jumpNode.tile_pos:
					opened = true
					break
			#----------------------------------------------------
			
			if !opened or ng < jumpNode.gy:
#				print("Open ", opened ," Distance ", ng , " ", jg)
				jumpNode.gy = ng
				
				if Autoload.heuristic:
					jumpNode.hy = jumpNode.hy or utils.manhattan(abs(jx - end_node.tile_pos.x), abs(jz - end_node.tile_pos.z))
				else: jumpNode.hy = jumpNode.hy or utils.euclidean(jumpNode.tile_pos, end_node.tile_pos)
				
				jumpNode.fy = jumpNode.gy + jumpNode.hy
				jumpNode.parent = current
				if !opened:
					open_list.append(jumpNode)
				else:
					open_list = []
					open_list.append(jumpNode)

func set_nav_tiles():

	var result = []
	
	for cell in gridmap.get_used_cells():
		var id_object =  gridmap.get_cell_item(cell.x, cell.y, cell.z)
		if id_object == nav_id:
#			if cell != block_cell:
			result.append(Vector3(cell.x, cell.y, cell.z))
		
	return result


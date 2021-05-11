extends Node
class_name JPFinder
var cell = Autoload.cell

func jump(neigh, current, end_node):
	
	var x = neigh.x
	var z = neigh.z
	
	var px = current.x
	var pz = current.z
	
	#direction
	var dX = x - px
	var dZ = z - pz
	
	if !isWalkAble(x, 0, z):
		return null

	if Vector3(x, 0, z) == end_node.tile_pos:
		return Vector3(x, 0, z)
	
	#diagonal
	if dX != 0 and dZ != 0:
		if isWalkAble(x - dX, 0, z + dZ) and !isWalkAble(x - dX, 0, z) or isWalkAble(x + dX, 0, z - dZ) and !isWalkAble(x, 0, z - dZ):
			return Vector3(x, 0, z)
		
		if jump(Vector3(x + dX, 0, z), Vector3(x, 0, z), end_node) or jump(Vector3(x, 0, z + dZ), Vector3(x, 0, z), end_node):
			return Vector3(x, 0, z)
	#horizontal
	else:
		if dX != 0:
			if isWalkAble(x + dX, 0, z + 1) and !isWalkAble(x, 0, z + 1) or isWalkAble(x + dX, 0, z - 1) and !isWalkAble(x, 0, z - 1):
				return Vector3(x, 0, z)
				
		else: 
			if isWalkAble(x + 1, 0, z + dZ) and !isWalkAble(x + 1, 0, z) or isWalkAble(x - 1, 0, z + dZ) and !isWalkAble(x - 1, 0, z):
				return Vector3(x, 0, z)

	return jump(Vector3(x + dX, 0, z + dZ) , Vector3(x, 0, z), end_node)



func find_neighbours(node):
	var parent = node.parent
	var x = node.tile_pos.x 
	var z = node.tile_pos.z
	var px
	var pz
#	var nx
#	var ny 
	var dx
	var dz
	
	var neighbours = []
	
	if parent:
		px = parent.tile_pos.x
		pz = parent.tile_pos.z
		
		dx = (x - px) / max(abs(x - px), 1)
		dz = (z - pz) / max(abs(z - pz), 1)
		
		# search diagonal
		if dx != 0 and dz != 0:
			
			if isWalkAble(x, 0, z + dz):
				neighbours.append(Vector3(x, 0, z + dz))
			
			if isWalkAble(x + dx, 0, z):
				neighbours.append(Vector3(x + dx, 0, z))
			
			if isWalkAble(x + dx, 0, z + dz):
				neighbours.append(Vector3(x + dx, 0, z + dz))
				
			if !isWalkAble(x - dx, 0, z):
				neighbours.append(Vector3(x - dx, 0, z + dz))
				
			if !isWalkAble(x, 0, z - dz):
				neighbours.append(Vector3(x + dx, 0, z - dz))
		# search horizontal / vertical
		else :
			
			if dx == 0:
				
				if isWalkAble(x, 0, z + dz):
					neighbours.append(Vector3(x, 0, z + dz))
					
				if !isWalkAble(x + 1, 0, z):
					neighbours.append(Vector3(x + 1, 0, z + dz))
					
				if !isWalkAble(x - 1, 0, z):
					neighbours.append(Vector3(x - 1, 0, z + dz))
					
			else:
				if isWalkAble(x + dx, 0, z):
					neighbours.append(Vector3(x + dx, 0, z))
				
				if !isWalkAble(x, 0, z + 1):
					neighbours.append(Vector3(x + dx, 0, z + 1))
					
				if !isWalkAble(x, 0, z - 1):
					neighbours.append(Vector3(x + dx, 0, z - 1))
					
	else:
		var neighNode = Autoload.get_neighbours(node)
		
		for itr_neigh in neighNode:
			neighbours.append(itr_neigh)
		
	return neighbours



func isWalkAble(x, y, z):
	if cell.has(Vector3(x, y, z)):
		return true
	else:
		return false
	

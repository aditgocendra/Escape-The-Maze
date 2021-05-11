extends Node
class_name Utility


func backtrace(current_node):
	var path = [current_node.tile_pos]
	var current = current_node
	var cost_node = 0
	while current.parent != null:
		current = current.parent
		cost_node += current.fy
		path.push_front(current.tile_pos)
		
	Autoload.cost_node_count = cost_node
	return path


func interpolate(x0, y0, z0, x1, y1, z1):
	var line = []
	var sx
	var sz
	var dx
	var dz
	var err
	var e2
	
	dx = abs(x1 - x0)
	dz = abs(z1 - z0)
	

	sx = 1 if x0 < x1 else -1
	sz = 1 if z0 < z1 else -1
	
	err = dx - dz
	
	while true:
		line.append(Vector3(x0, y0, z0))
		
		if x0 == x1 and z0 == z1:
			break
			
		e2 = 2 * err
		if e2 > -dz:
			err = err - dz
			x0 = x0 + sx
			
		if e2 < dx:
			err = err + dx
			z0 = z0 + sz
			
	return line
		
func expandPath(path : Array):
	var expanded = []
	var length = path.size()
	var coord1
	var coord2
	var interpolated
	var interpolatedLen
	
	
#	if length < 2:
#		return expanded
		
	for i in range(length - 1):
		coord1 = path[i] 
		coord2 = path[i + 1] 
		interpolated = interpolate(coord1[0], coord1[1], coord1[2], coord2[0], coord2[1], coord2[2])
		interpolatedLen = interpolated.size()
		for j in range(interpolatedLen - 1):
			expanded.append(interpolated[j])
		
	expanded.append(path[length - 1])
	return expanded



func octile(dx, dy):
	var F = sqrt(2) - 1
	if dx < dy:
		return F * dx + dy
	else: return F * dy + dx


func manhattan(dx, dy):
	return(dx + dy)

func euclidean(parent_s, neighbour_s):
	var dx = abs(neighbour_s.x - parent_s.x)
	var dz = abs(neighbour_s.z - parent_s.z)
	
	return sqrt(dx * dx + dz * dz)

func diagonal_distance(dx, dy):
	var H = 1 * max(dx, dy) + (sqrt(2) - 2 * 1) * min(dx, dy)
	return H

extends Spatial

onready var sphere = preload("res://src/Testing/Sphere.tscn").instance()

onready var sphere_group = $GroupSphere
onready var line = $Line3D

func _ready():
	Autoload.connect("path_solution", self, "create_line_path")
	

func create_line_path():
	var path = Autoload.path_count
#	sphere_group.remove_and_skip()
	clear_sphere()
	if not path.empty():
		
		line.begin(Mesh.PRIMITIVE_LINE_STRIP)
		
		for pos_path in path:
			var new_sphere = sphere.duplicate()
			sphere_group.add_child(new_sphere)
			new_sphere.global_transform.origin = Vector3(pos_path.x, 2, pos_path.z)
			line.add_vertex(Vector3(pos_path.x, 2, pos_path.z))
		
		line.end()


func clear_sphere():
	line.clear()
	for child in sphere_group.get_children():
		child.queue_free()
		

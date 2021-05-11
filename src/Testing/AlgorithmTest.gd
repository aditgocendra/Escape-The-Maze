extends Control

onready var check_JPS = $ControlBackground/VBoxContainer/ContainerJPS/CheckJPS
onready var check_Theta = $ControlBackground/VBoxContainer/ContainerTheta/CheckTheta
onready var check_NPC = $ControlBackground/VBoxContainer/ContainerPlay/CheckPlay
onready var check_Manhattan = $HeuristicBackground/ContainerHeristic/ContainerManhattan/ManhattanCheck
onready var check_Euclidean = $HeuristicBackground/ContainerHeristic/ContainerEuclidean/EuclideanCheck

onready var value_PathS = $ResultBackground/VBoxContainer/ContainerPathS/ValueSolution
onready var value_OpenNode = $ResultBackground/VBoxContainer/ContainerOpenNode/ValueSolution
onready var value_Time = $ResultBackground/VBoxContainer/ContainerTime/ValueSolution
onready var value_Memory = $ResultBackground/VBoxContainer/ContainerMemory/ValueSolution
onready var value_VisitedNode = $ResultBackground/VBoxContainer/ContainerVisitedNode/ValueSolution
onready var value_CostNode = $ResultBackground/VBoxContainer/ContainerCost/ValueSolution
onready var value_FPS = $ResultBackground/VBoxContainer/ContainerFPS/ValueSolution
onready var value_PosPlayer = $ContainerPos/ContainerPosPlayer/ValuePosPlayer
onready var value_PosEnemy = $ContainerPos/ContainerPosEnemy/ValuePosEnemy

onready var total_path = $ResultBackground/TotalPathS
onready var option_cell = $ControlBackground/VBoxContainer/OptionCell

onready var line3D = get_parent().get_node("LinePath")
onready var player = get_parent().get_node("Gridmap/Player")
onready var enemy = get_parent().get_node("Gridmap/Enemy")
onready var gridmap = get_parent().get_node("Gridmap")

var path_count

var popup
var drag_popup = false

func _ready():
	# connect to autoload file with signal file autoload
	Autoload.connect("path_solution", self, "change_value_ps")
	Autoload.connect("open_node", self, "change_value_open_node")
	Autoload.connect("time_usage", self, "change_time_usage")
	Autoload.connect("memory_usage", self, "change_memory_usage")
	Autoload.connect("visited_node", self, "change_visited_node")
	Autoload.connect("cost_node", self, "change_cost_node")
	
	enemy.tested_algorithm = true
	add_item_option_cell()
	
	# connect with popup menu for scroll in android
	popup = option_cell.get_popup()
	popup.connect("gui_input", self, "_on_popup_input")

func _process(_delta):
	value_FPS.text = str(Engine.get_frames_per_second())
	value_PosPlayer.text = str(get_pos_cell(player.global_transform.origin))
	value_PosEnemy.text = str(get_pos_cell(enemy.global_transform.origin))


func _on_popup_input(event):
	drag_popup = false
	if event is InputEventScreenDrag:
		drag_popup = true
		popup.rect_position.y += event.relative.y
	

func add_item_option_cell():
	var cell = Autoload.cell
	for index_cell in cell:
		option_cell.add_item(str(index_cell))



func change_value_ps():
	# path solution size 
	value_PathS.text = str(Autoload.path_count.size())
	
	# path result solutin
	total_path.text = " "
	for path in Autoload.path_count:
		total_path.text = str(total_path.text, "\n", path)
		
	
	
func change_value_open_node():
	value_OpenNode.text = str(Autoload.open_node_count)
	
	
func change_time_usage():
	value_Time.text = str(Autoload.time_usage_count) + " ms"

func change_memory_usage():
	# convert byte to kilobyte
	var kb = Autoload.memory_usage_count / 1024
	value_Memory.text = str(kb) + " Kb"
	
func change_visited_node():
	value_VisitedNode.text = str(Autoload.closed_node_count)
	
func change_cost_node():
	value_CostNode.text = str(Autoload.cost_node_count)


func get_pos_cell(global_pos):
	var pos = gridmap.world_to_map(global_pos)
	return pos
	

func _on_CheckJPS_pressed():
	check_Theta.pressed  = false


func _on_CheckTheta_pressed():
	check_JPS.pressed = false


func _on_Start_pressed():
	if check_Manhattan.pressed:
		Autoload.heuristic = true
	elif check_Euclidean.pressed:
		Autoload.heuristic = false
	else : Autoload.heuristic = false
	
	if check_JPS.pressed or check_Theta.pressed:
		if check_JPS.pressed:
			enemy.algorithm = 0
		else: enemy.algorithm = 1
		
		if check_NPC.pressed:
			enemy.state = 1
			enemy.timer.start()
		else:
			enemy.state = 0
			enemy.find_path_timer()


func _on_Stop_pressed():
	enemy.state = 0
	enemy.timer.stop()
	check_Theta.pressed  = false
	check_JPS.pressed  = false
	check_NPC.pressed  = false
	


func _on_Clear_pressed():
	if !check_JPS.pressed or !check_Theta.pressed:
		Autoload.path_count = []
		Autoload.open_node_count = []
		Autoload.memory_usage_count = 0
		Autoload.time_usage_count = 0
		Autoload.closed_node_count = 0
		Autoload.cost_node_count = 0
		line3D.clear_sphere()


func _on_OptionCell_item_selected(index):
	if drag_popup == false:
		Autoload.enemy_pos = Autoload.cell[index]


func _on_ManhattanCheck_pressed():
	check_Euclidean.pressed = false


func _on_EuclideanCheck_pressed():
	check_Manhattan.pressed = false

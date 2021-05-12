extends KinematicBody


const speed = 5.0

var target = null
var velocity = Vector3.ZERO

var path = []


var path_plan
var path_solution = []
var timer

var default_pos_monster

var random_pos_monster
var count_random = 0

enum STATE {IDLE, RUN, ATTACK, BACK}
enum ALGORITHM {JumpPS, Theta}


var state = STATE.IDLE
var algorithm = ALGORITHM.Theta
var tested_algorithm = false

var look_at_pos = Vector3.ZERO

func _ready():
	Autoload.connect("enemy_change_state", self, "_on_change_state")
	Autoload.connect("enemy_position_update", self, "_on_update_position")
	default_pos_monster = self.global_transform.origin
#	var block = get_parent().get_parent().get_node("GroupObject/CupboardContainer")
	self.set_physics_process(false)
	
	if algorithm == ALGORITHM.JumpPS:
		path_plan = JPS.new(get_parent(), 0)
	else : path_plan = ThetaStar.new(get_parent(), 0)
	
	timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.connect("timeout", self, "find_path_timer")
	
	randomize()

func _physics_process(_delta):
	
	match state: 
		STATE.IDLE:
			$AnimationPlayer.play("Tpose")
		STATE.RUN:
			self.look_at(look_at_pos,Vector3.UP)
			if path.size() > 0:
				move_along_path(path)
				
				$AnimationPlayer.play("Walk")
				if !$Walk.is_playing():
					$Walk.play()
		STATE.BACK:
			if path.size() > 0:
				move_along_path(path)
			if path_plan.gridmap.world_to_map(self.global_transform.origin) == random_pos_monster:
				state = STATE.IDLE
				count_random = 0
		STATE.ATTACK:
			if $AnimationPlayer.current_animation != "Attack":
				$AnimationPlayer.play("Attack")



func move_along_path(path):
	if global_transform.origin.distance_to(path[0]) < 1.0:
		path.remove(0)
		
		if path.size() == 0:
			return
	look_at_pos = path[0]
	velocity = (path[0] - global_transform.origin).normalized() * speed
	velocity = move_and_slide(velocity, Vector3.UP, false)


func set_target(target):
	self.target = target
	self.set_physics_process(true)
	if state == STATE.RUN:
		find_path_timer()


func find_path_timer():
	
	#check algorithm use
	if algorithm == ALGORITHM.JumpPS:
		path_plan = JPS.new(get_parent(), 0)
	else : path_plan = ThetaStar.new(get_parent(), 0)
	
	var self_pos_map = path_plan.gridmap.world_to_map(global_transform.origin)
	
	var target_pos_map 
	
	if state == STATE.BACK:
		random_pos()
		target_pos_map = random_pos_monster
	else : 
		var target_global_trans = target.global_transform.origin
		target_global_trans.y = 0
		target_pos_map = path_plan.gridmap.world_to_map(target_global_trans)
	
	path_solution = path_plan.find_path(self_pos_map, target_pos_map)
	path = path_solution
	
	
	path.remove(0)


func _on_AreaRun_body_entered(body):
	if body.name == "Player":
		state = STATE.RUN
		timer.start()


func _on_AreaAttack_body_entered(body):
	if body.name == "Player":
		body.die(self)
		state = STATE.ATTACK

func change_state(new_state : int):
	Autoload.prev_enemy_state = state
	if new_state == 0:
		state = STATE.IDLE
	
	if new_state == 1:
		state = STATE.RUN
	
	if new_state == 2:
		state = STATE.CATCH
	
	if new_state == 3 and state != STATE.IDLE:
		state = STATE.BACK

	
func _on_change_state():
	change_state(Autoload.enemy_state)

func _on_update_position():
	var map_pos = Autoload.enemy_pos
	self.global_transform.origin =  path_plan.gridmap.map_to_world(map_pos.x, map_pos.y, map_pos.z)
	

func random_pos():
	if count_random < 1:
		random_pos_monster = Autoload.cell[randi() % Autoload.cell.size()]
		count_random += 1
	

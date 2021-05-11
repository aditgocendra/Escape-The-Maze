extends Actor



var speed
var default_speed = 3
var sprint_speed = 8
var acceleration = 13


var mouse_sensitivity = 0.05

var velocity = Vector3.ZERO
var direction = Vector3.ZERO
var fall = Vector3.ZERO
var shake_amount = 0.01


onready var head = $Head
onready var camera = $Head/Camera
onready var joystick = $Controller/LeftContainer/Joystick/ButtonJoystick

onready var pause_instance = preload("res://src/UserInterface/Pause/Pause.tscn").instance()


var sprinting = false
var forward = false
var solving_puzzle = false
var target
var is_climb = false
var state
enum STATE {IDLE, RUN, CLIMB, DEAD}


func _ready():
	var data = Database.loadData()
	mouse_sensitivity = data["game"]["settings"]["sensitivity"]
	state = STATE.IDLE
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$Fader.connect("fade_finish", self, "on_fade_finish")
	$Fader.show()
	$Fader._fade_in()
	
	
	
func _input(event):
	if event is InputEventMouseMotion:
		if not solving_puzzle: 
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	
	if event is InputEventScreenDrag:
		if event.index == joystick.ongoing_drag:
			return 
		if not solving_puzzle:
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	
	
	if event.is_action_pressed("climb") and is_climb == false:
		gravity = 0
		is_climb = true
		$TimerClimb.start()
		$Controller/ContainerClimb.show()
		Autoload.enemy_state = 3
		
	if event.is_action_pressed("down_climb"):
		gravity = 30
		is_climb = false
		$Controller/ContainerClimb.hide()


func _physics_process(delta):

	direction = Vector3.ZERO
	
	if is_climb == true:
		self.global_transform.origin.y += 4 * delta 
		
		
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	android_controller()
		
	if state != STATE.DEAD:
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		if Input.is_action_just_pressed("ui_focus_next"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		if not solving_puzzle and not is_climb and global_transform.origin.y < 2:
			if Input.is_action_pressed("move_forward"):
				direction -= transform.basis.z
				forward = true
			else: forward = false
			
			if Input.is_action_pressed("move_backward"):
				direction += transform.basis.z
				
			if Input.is_action_pressed("move_left"):
				direction -= transform.basis.x
				
			if Input.is_action_pressed("move_right"):
				direction += transform.basis.x
				
			if Input.is_action_pressed("sprint"):
				sprinting = true
				
			else: sprinting = false
			
			if sprinting:
				speed = sprint_speed
			else: speed = default_speed
	else : 
		
		rotation_degrees.y = lerp(rotation_degrees.y, target.global_transform.origin.z, 0.2)
		shake_amount += 0.02 * delta
		camera.h_offset = rand_range(-1, 1) * shake_amount
		camera.v_offset = rand_range(-1, 1) * shake_amount
	
	
#	direction with keyboard
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
		
	if direction != Vector3.ZERO:
		if sprinting:
			$AnimationPlayer.play("ShakeCameraSprint")
		else: 
			$AnimationPlayer.play("ShakeCameraWalk")



func android_controller():
	var value_joy = joystick.get_value().normalized().rotated(-rotation.y)
	if state != STATE.DEAD:
		if not solving_puzzle and not is_climb and global_transform.origin.y < 2:
			direction.z = value_joy.y
			direction.x = value_joy.x
			if value_joy.y != 0:
				forward = true
			else: forward = false



func on_fade_finish(anim_name):
	if anim_name == "fade_out_in":
		camera.environment.dof_blur_far_enabled = true
		$Fader.hide()
		solving_puzzle = true
	
	if anim_name == "fade_in":
		$Controller/Objective/ObjectiveAnim.play("play")
		$Fader.hide()
	
	if anim_name == "game_over":
		get_tree().change_scene("res://src/UserInterface/MainMenu/3DSceneMenu.tscn")
	
	if anim_name == "fade_out":
		get_tree().change_scene("res://src/UserInterface/MainMenu/3DSceneMenu.tscn")
		$Fader.hide()
		
		

func die(enemy):
	state = STATE.DEAD
	target  = enemy
	$Fader.show()
	$Fader._game_over()
	

func win():
	$Fader.show()
	$Fader._fade_out()


func _on_TimerClimb_timeout():
	is_climb = false



func _on_Pause_pressed():
	$Controller.add_child(pause_instance)
	pause_instance = preload("res://src/UserInterface/Pause/Pause.tscn").instance()
	get_tree().paused = true




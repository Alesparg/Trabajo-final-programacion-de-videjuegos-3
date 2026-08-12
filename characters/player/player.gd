@tool
#modo tool, el codigo se ejecutara en el editor
extends CharacterBody2D
class_name Player

# This demo shows how to build a kinematic controller.

# Member variables

#Las dejé en mayúsculas pero son variables
#Aunque su uso interno es constante, discutible
@export var GRAVITY: float = 500.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
@export var FLOOR_ANGLE_TOLERANCE: float = 40
@export var WALK_FORCE: float = 600
@export var WALK_MIN_SPEED: float = 10
@export var WALK_MAX_SPEED: float = 200
@export var STOP_FORCE: float = 1300
@export var JUMP_SPEED: float = 200: set = _set_jump_speed
@export var JUMP_MAX_AIRBORNE_TIME: float = 0.2

@export var SLIDE_STOP_VELOCITY: float = 1.0 # One pixel per second
@export var SLIDE_STOP_MIN_TRAVEL: float = 1.0 # One pixel

#son variables necesarias para la lógica, no conviene exponerlas
var on_air_time = 100
var jumping = false

var jump_curve = PackedVector2Array()

#Se puede seleccionar la escena que representa la explosión
@export var Explosion: PackedScene
var boom

# Sistema de vida
var max_health = 3
var current_health = 3

signal im_dead
signal health_changed

# Sistema de power-up de velocidad
var base_walk_force: float = 600.0
var base_walk_max_speed: float = 200.0
var speed_boost_timer: float = 0.0
var speed_boost_duration: float = 12.0
var has_speed_boost: bool = false

func activate_speed_boost():
	has_speed_boost = true
	speed_boost_timer = speed_boost_duration
	WALK_FORCE = base_walk_force * 2.0
	WALK_MAX_SPEED = base_walk_max_speed * 2.0

func _ready():
	if Engine.is_editor_hint(): #para que haga draw sólo en tool mode
		jump_curve.resize(5)
		calculate_jump_curve()
		queue_redraw()
	else:
		if Explosion != null:
			boom = Explosion.instantiate()

func _physics_process(delta): 
	#para que no procese lógica de juego en tool mode
	if Engine.is_editor_hint(): 
		#de ser necesario se puede agregar lógica de editor
		return
	
	# Manejar timer de speed boost
	if has_speed_boost:
		speed_boost_timer -= delta
		if speed_boost_timer <= 0.0:
			has_speed_boost = false
			WALK_FORCE = base_walk_force
			WALK_MAX_SPEED = base_walk_max_speed
	
	# Create forces
	var accel = Vector2(0, GRAVITY)
	
	#Hay muchas maneras de obtener inputs, algunas más compactas
	#pero a veces se pueden necesitar detalles individuales 
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_just_pressed("jump")
	
	var stop = true
	$WalkDust.emitting = false
	
	#Ajustes visuales
	if (walk_left):
		$Body.scale.x = -1
		if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			accel.x -= WALK_FORCE
			stop = false
			
			$WalkDust.process_material.direction.x = 1
	elif (walk_right):
		$Body.scale.x = 1
		if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			accel.x += WALK_FORCE
			stop = false
			$WalkDust.process_material.direction.x = -1
	
	#Resbalar al frenar para mejorar el feel
	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE*delta
		if (vlen < 0):
			vlen = 0
		
		velocity.x = vlen*vsign
	
	# Integrar las aceleraciones a la velocidad
	velocity += accel*delta
	
	# mover y consumir el movimiento
	# esta función ejecuta move_and_collide varias veces usando los datos
	# propios de la instancia como velocity y arrastra los cuerpos
	# a lo largo de una superficie acorde a la normal de colisión
	move_and_slide()
	
	#Ajustes post-movimiento
	if is_on_floor():
		on_air_time = 0
		if velocity.length_squared()>0:
			$WalkDust.emitting = true
		
	
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if (on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not jumping):
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
		$JumpDust.emitting = true
	
	on_air_time += delta

func take_damage(damage_amount: int = 1):
	current_health -= damage_amount
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		explode()

func explode():
	# no intentar matarlo dos veces
	if is_queued_for_deletion():
		return

	if boom is Node2D: #no puedo set_pos si no extiende Node2D  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		boom.position = global_position
		get_tree().current_scene.add_child(boom)
	im_dead.emit()
	queue_free()

# Setters y utilidades visuales
func _set_jump_speed(js):
	JUMP_SPEED = js
	calculate_jump_curve()
	queue_redraw()
	

#maxima parabola dada por un salto
func calculate_jump_curve():
	var t = 2*JUMP_SPEED/GRAVITY
	
	for i in range(0,jump_curve.size()):
		var current_time = t / jump_curve.size() * (i+1)
		jump_curve[i].x = WALK_MAX_SPEED/jump_curve.size() * (i+1) #aprox
		jump_curve[i].y = -(JUMP_SPEED*current_time-pow(current_time,2)*GRAVITY / 2) + $CollisionShape2D.shape.extents.y

func _draw():
	if Engine.is_editor_hint():
		#velocidad del salto, puede ser mas util mostrar la altura maxima
		draw_line(Vector2(),Vector2(0,-JUMP_SPEED*0.2),Color(1,0,0),3)
		#fuerza de caminar, en escala arbitraria para referencia
		draw_line(Vector2(),Vector2(WALK_FORCE*0.05,0),Color(0,1,0),3)
		#angulo del piso soportado
		draw_line(Vector2(),Vector2(30, 0).rotated(deg_to_rad(FLOOR_ANGLE_TOLERANCE-45)),Color(0,0,1),3)
		#parabola del salto
		for point in jump_curve:
			draw_circle(point,3,Color.VIOLET)

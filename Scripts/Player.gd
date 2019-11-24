extends KinematicBody2D

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -220
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://Escenas/Area2D.tscn")

var velocity=Vector2()
var on_ground=false
var is_attacking = false
var is_dead=false
var barravida
var dead = false

export (int) var hp = 6
export var vida_actual = 6

func _ready():
	barravida = get_tree().get_nodes_in_group("vida")[0]

func _process(delta):
	actualizar_barrahp()
	
	if Input.is_action_just_pressed("ui_right") and is_on_floor() and hp != 0:
		$AudioStreamPlayer.play()
		
	elif Input.is_action_just_pressed("ui_left") and is_on_floor() and hp != 0:
		$AudioStreamPlayer.play()
		
	elif Input.is_action_just_released("ui_right") and hp != 0:
		$AudioStreamPlayer.stop()
			
	elif Input.is_action_just_released("ui_left") and hp != 0:
		$AudioStreamPlayer.stop()
		
	if Input.is_action_pressed("ui_up") and is_on_floor() == true and hp != 0:
		$AudioStreamPlayer2.play()
		
	elif Input.is_action_just_pressed("ui_up") and is_on_floor() == false and hp != 0:
		$AudioStreamPlayer2.play()
	if Input.is_action_just_pressed("ui_focus_next") and hp != 0:
		$AudioStreamPlayer3.play()

func _physics_process(delta):
	
	if is_dead == false:
	
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = SPEED 
				if is_attacking == false:
					$AnimatedSprite.play("walk")
					$AnimatedSprite.flip_h=false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
		
		elif Input.is_action_pressed("ui_left") :
			if is_attacking == false || is_on_floor() == false:
				velocity.x = -SPEED
				if is_attacking == false:
					$AnimatedSprite.play("walk")
					$AnimatedSprite.flip_h=true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
		
		else:
			velocity.x = 0
			if on_ground==true && is_attacking == false:
				$AnimatedSprite.play("idle")
		
		if Input.is_action_pressed("ui_up"):
			if is_attacking == false:
				if on_ground==true:
					velocity.y = JUMP_POWER 
					on_ground=false
		
		if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			$AnimatedSprite.play("attack")
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == 1:
				fireball.set_direction(1)
			else:
				fireball.set_direction(-1)
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
	
		velocity.y+=GRAVITY
		
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0:
					$AnimatedSprite.play("jump")
				else:
					$AnimatedSprite.play("fall")
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()
					
		

func dead():
	dead=true
	print(dead)
	is_attacking=false
	$AudioStreamPlayer.stop()
	
	$AnimatedSprite.play("dead")
	vida_actual -= 1
	if vida_actual == 0:
		is_dead=true
		#velocity=Vector2(0,0)
		$CollisionShape2D.disabled = true
		$Timer.start()

	

func _on_AnimatedSprite_animation_finished():
	is_attacking = false

func actualizar_barrahp():
	barravida.value = vida_actual * barravida.max_value / hp

func _on_Timer_timeout():
	get_tree().change_scene("res://Escenas/TitleScreen.tscn")

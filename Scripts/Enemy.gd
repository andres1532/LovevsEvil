extends KinematicBody2D

const GRAVITY = 10
const FLOOR = Vector2(0,-1)

#------------------INTENTAR CON EL VECTOR2 PARA QUE NO SE CAIGA EL ENEMIGO--------------------

var velocity  = Vector2()
var posicion = Vector2()
var direction = 1
var acceleration = 10
var is_dead = false
var attack = false 
export (int) var speed = 30
export (int) var hp = 2


func _ready():
	posicion = global_position
	pass

func dead():
	hp -= 1
	if hp == 0:
		is_dead=true
		velocity=Vector2(0,0)
		$AnimatedSprite.play("dead")
		$Timer.start()
		
	
func _process(delta):
	
	var player = get_tree().get_nodes_in_group("player")[0].global_position
	var yo = global_position
	if(player.x > (posicion.x - 100) and player.y < yo.y+100 and player.x < (posicion.x + 100) and player.y > yo.y-100):
		if(player.x < yo.x and player.y < yo.y+100):
			attack = true
			direction = -1
		if(player.x > yo.x and player.y > yo.y-100):
			attack = true
			direction = 1
		
		else:
			attack = false
		if global_position.x <= (posicion.x - 100) and !attack:
			direction = 1
			pass
		if global_position.x >= (posicion.x + 100) and !attack:
			direction = -1
			pass
		
			
			
	
func _physics_process(delta):
	if is_dead == false: 
		
		velocity.x = speed * direction
		 
		if direction == 1:
			$AnimatedSprite.flip_h = false 
		else:
			$AnimatedSprite.flip_h = true
			
		$AnimatedSprite.play("walk")
		
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)
	else:
		$CollisionShape2D.disabled=true
	if is_on_wall():
		direction = direction * -1
	
	if get_slide_count() > 0:
		for i in range (get_slide_count()):
			if "Player" in get_slide_collision(i).collider.name:
				get_slide_collision(i).collider.dead()
	
	

				
	

func _on_Timer_timeout():
	queue_free()

	

	
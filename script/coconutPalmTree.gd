extends Node2D

var state = "noCoconuts"
var player_in_area = false
var object_pressed = false
var selected_num = 0
var selected_sprite = ["",""]
var coconut = preload("res://scenes/coconut_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	random_Sprite()
	if state == "noCoconuts":
		$growth_Timer.start()
		
func _process(_delta):
	if state == "noCoconuts":
		$AnimatedSprite2D.play(selected_sprite[1])
	if state == "coconuts":
		$AnimatedSprite2D.play(selected_sprite[0])
		if player_in_area:
			if player_in_area and object_pressed:
				state = "noCoconuts"
				dropCoconut()
				object_pressed = false



func _on_interaction_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true


func _on_interaction_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false


func _on_growth_timer_timeout():
	if state == "noCoconuts":
		state = "coconuts"
		
func dropCoconut():
	var coconut_instance = coconut.instantiate()
	coconut_instance.global_position = $Marker2D.global_position
	get_parent().add_child(coconut_instance)
	
	await get_tree().create_timer(3).timeout
	$growth_Timer.start()


func _on_interaction_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		object_pressed = true

func random_Sprite():
	selected_num = randi()%3
	if selected_num == 0:
		selected_sprite[0] = "coconuts"
		selected_sprite[1] = "noCoconuts"
	if selected_num == 1:
		selected_sprite[0] = "coconuts1"
		selected_sprite[1] = "noCoconuts1"
	if selected_num == 2:
		selected_sprite[0] = "coconuts2"
		selected_sprite[1] = "noCoconuts2"
	

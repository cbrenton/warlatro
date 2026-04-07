extends Node2D

'''
# 1. Load the scene (blueprint) once
@export var item_to_spawn: PackedScene 
# OR use: const ITEM_SCENE = preload("res://my_item.tscn")

func spawn_item():
    # 2. Create a new instance of the scene
    var new_node = item_to_spawn.instantiate()
    
    # 3. Set properties (optional)
    new_node.position = Vector2(100, 200)
    
    # 4. Add it to the current node's children to make it appear
    add_child(new_node)
'''


const CARD_SCENE = preload("res://card.tscn")

func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				card.flip()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_specific_card(100, 2, "hearts")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result:
		return result[0].collider.get_parent()
	return null

func spawn_card(x):
	var new_card = CARD_SCENE.instantiate()
	new_card.position = Vector2(x, 200)
	add_child(new_card)

func spawn_specific_card(x, rank, suit):
	var new_card = CARD_SCENE.instantiate()
	# new_card.initialize(rank, suit)
	new_card.initialize()
	new_card.position = Vector2(x, 200)
	add_child(new_card)

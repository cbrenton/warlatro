extends Node2D


const CARD_SCENE = preload("res://card.tscn")
const DECK_SCENE = preload("res://deck.tscn")

func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				card.flip()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var deck = DECK_SCENE.instantiate()
	deck.shuffle()
	var i = 0
	while not deck.empty():
		self.deal_from_deck(deck, 100 * i + 100)
		i += 1

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

func deal_from_deck(deck, x_pos):
	var card = deck.deal_top()
	card.position = Vector2(x_pos, 200)
	add_child(card)

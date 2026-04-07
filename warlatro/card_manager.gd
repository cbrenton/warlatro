extends Node2D

const DECK_SCENE = preload("res://deck.tscn")
const STACK_SCENE = preload("res://stack.tscn")

var player_stack;
var cpu_stack;
var deck;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.deck = DECK_SCENE.instantiate()
	self.deck.shuffle()

	self.player_stack = STACK_SCENE.instantiate()
	self.player_stack.initialize(Vector2(100, 200))

	self.cpu_stack = STACK_SCENE.instantiate()
	self.cpu_stack.initialize(Vector2(300, 200))

	# add stacks to scene
	add_child(self.player_stack)
	add_child(self.cpu_stack)

	# while not self.deck.empty():
	for i in range(3):
		self.player_stack.add_card(self.deck.deal_top())
		self.cpu_stack.add_card(self.deck.deal_top())

	self.player_stack.display_first_card()
	self.cpu_stack.display_first_card()

func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				card.handle_click()

func deal_from_deck(x_pos):
	var card = self.deck.deal_top()
	card.position = Vector2(x_pos, 200)
	add_child(card)

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

# at beginning, create player stack
# deal from deck, add child to stack
func handle_click():
	var player_card = self.player_stack.next_turn()
	var cpu_card = self.cpu_stack.next_turn()
	if self.player_stack.has_turns_left() and self.cpu_stack.has_turns_left():
		if player_card and cpu_card:
			print("comparing two cards")
		else:
			print("ready for next turn")
	else:
		print("game over")

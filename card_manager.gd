extends Node2D

const DECK_SCENE = preload("res://deck.tscn")
const STACK_SCENE = preload("res://stack.tscn")

var player_stack;
var cpu_stack;
var deck;
var is_game_ended = false
var _js_callback  # must hold a reference to prevent GC

@onready var my_label = $WinLabel

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

	while not self.deck.empty():
		self.player_stack.add_card(self.deck.deal_top())
		self.cpu_stack.add_card(self.deck.deal_top())

	self.player_stack.display_first_card()
	self.cpu_stack.display_first_card()

	if OS.get_name() == "Web":
		_js_callback = JavaScriptBridge.create_callback(_on_rcade_input)
		JavaScriptBridge.get_interface("window")["_godot_input_cb"] = _js_callback

func _on_rcade_input(args) -> void:
	var button = args[0]
	var pressed = args[1]
	if button == "A" and pressed:
		handle_click()

func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				card.handle_click()

func _process(_delta) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
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
	if self.is_game_ended:
		return

	var player_card = self.player_stack.next_turn()
	var cpu_card = self.cpu_stack.next_turn()
	# TODO: simplified version
	# if win condition not met:
	# 	play next turn
	# 	check win condition
	# else:
	# 	play win screen
	if self.player_stack.has_turns_left() and self.cpu_stack.has_turns_left():
		if player_card and cpu_card:
			var result = player_card.compare(cpu_card)
			if result < 0:
				self.cpu_stack.win_card(player_card)
				self.cpu_stack.win_card(cpu_card)
			elif result == 0:
				self.player_stack.win_card(player_card)
				self.cpu_stack.win_card(cpu_card)
			else:
				self.player_stack.win_card(player_card)
				self.player_stack.win_card(cpu_card)
	else:
		self.is_game_ended = true
		self.player_stack.set_label()
		self.cpu_stack.set_label()
		if not self.player_stack.cards.is_empty():
			$WinLabel.text = "You win!"
		else:
			$WinLabel.text = "You lose!"

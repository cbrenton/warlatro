extends Node2D


var cards = []
var pos: Vector2
var visible_card

func initialize(pos: Vector2) -> void:
	self.pos = pos

func add_card(card) -> void:
	self.cards.push_back(card)

func show_top() -> void:
	self.visible_card = self.cards.pop_back()
	self.visible_card.position = self.pos
	add_child(self.visible_card)

func handle_click():
	# call flip on top card
	# if top card gets deleted, add next top card
	var was_deleted = self.visible_card.flip()
	if was_deleted and not self.cards.is_empty():
		show_top()

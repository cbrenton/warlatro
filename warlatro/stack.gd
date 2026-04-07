extends Node2D


var cards = []
var pos: Vector2
var visible_card

@onready var my_label = $CardsLeftLabel

func initialize(pos_in: Vector2) -> void:
	self.pos = pos_in

func add_card(card) -> void:
	self.cards.push_back(card)

func win_card(card) -> void:
	self.cards.push_front(card)

# returns a Node of type Card
func display_new_card():
	self.visible_card = self.cards.pop_back()
	if not self.visible_card:
		return
	self.visible_card.position = self.pos
	add_child(self.visible_card)
	my_label.position = self.pos + Vector2(-100, -200)
	self.set_label()

# returns a Node of type Card
func next_turn() -> Node:
	if self.visible_card:
		var should_be_deleted = self.visible_card.flip()
		if not should_be_deleted:
			return self.visible_card
		else:
			remove_child(self.visible_card)
			display_new_card()
	return null

func empty():
	return len(self.cards) == 0 and self.visible_card != null

func display_first_card() -> void:
	display_new_card()

func has_turns_left() -> bool:
	return self.visible_card != null

func cards_left() -> int:
	return len(self.cards) + (1 if self.visible_card else 0)

func set_label() -> void:
	my_label.text = "%d cards left" % [self.cards_left()]

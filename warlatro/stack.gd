extends Node2D


var cards = []
var pos: Vector2
var visible_card

func initialize(pos: Vector2) -> void:
	self.pos = pos

func add_card(card) -> void:
	self.cards.push_back(card)

# returns a Node of type Card
func display_new_card():
	self.visible_card = self.cards.pop_back()
	if not self.visible_card:
		return
	self.visible_card.position = self.pos
	add_child(self.visible_card)

# returns a Node of type Card
func next_turn() -> Node:
	if self.visible_card:
		var was_deleted = self.visible_card.flip()
		if not was_deleted:
			return self.visible_card
		else:
			display_new_card()
	return null

func empty():
	return len(self.cards) == 0 and self.visible_card != null

func display_first_card() -> void:
	display_new_card()

func has_turns_left() -> bool:
	return self.visible_card != null

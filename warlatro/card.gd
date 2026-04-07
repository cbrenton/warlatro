extends Node2D

const SUITS = ["hearts", "clubs", "diamonds", "spades"]
const RANKS = {
	2: "2",
	3: "3",
	4: "4",
	5: "5",
	6: "6",
	7: "7",
	8: "8",
	9: "9",
	10: "10",
	11: "jack",
	12: "queen",
	13: "king",
	14: "ace",
}

var rank = 0
var suit = null
var texture = null
var rng;
var is_flipped = false;

# returns true if card deleted
func flip() -> bool:
	if self.is_flipped:
		queue_free()
		return true
	else:
		$Sprite2D.texture = self.texture
		self.is_flipped = true
		return false

func handle_click():
	get_parent().get_parent().handle_click()

# rank is a string
func initialize(rank = null, suit = null):
	if rank and suit:
		self.rank = rank
		self.suit = suit
	else:
		print("no rank or suit passed")

	var texture_path = "res://assets/cards/%s_of_%s.png" % [self.rank, self.suit]
	self.texture = load(texture_path)

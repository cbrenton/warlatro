extends Node2D

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

	#var texture_path = "res://assets/cards/%s_of_%s.png" % [self.rank, self.suit]
	var texture_path = "res://assets/cards/card_%s_%s.png" % [self.suit, self.rank]
	self.texture = load(texture_path)

# other is a Node of type Card
# returns -1 if loses to other, 0 if ties, 1 if beats
func compare(other: Node) -> int:
	if other.rank > self.rank:
		return -1
	if other.rank == self.rank:
		return 0
	return 1

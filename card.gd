extends Node2D

var rank_value = 0
var rank_str = null
var suit_value = null
var suit_str = null
var texture = null
var back_texture = null
var rng
var is_flipped = false

# returns true if card should be deleted
func flip() -> bool:
	if self.is_flipped:
		$Sprite2D.texture = self.back_texture
		self.is_flipped = false
		return true
	else:
		$Sprite2D.texture = self.texture
		self.is_flipped = true
		return false

func handle_click():
	get_parent().get_parent().handle_click()

# rank is a string
func initialize(rank_value = null, rank_str = null, suit_value = null, suit_str = null):
	if rank_value and rank_str and suit_value:
		self.rank_value = rank_value
		self.rank_str = rank_str
		self.suit_value = suit_value
		self.suit_str = suit_str
	else:
		print("no rank or suit passed")

	var texture_path = "res://assets/cards/card_%s_%s.png" % [self.suit_str, self.rank_str]
	self.texture = load(texture_path)
	var back_texture_path = "res://assets/cards/card_back.png"
	self.back_texture = load(back_texture_path)

# other is a Node of type Card
# returns -1 if loses to other, 0 if ties, 1 if beats
func compare(other: Node) -> int:
	if other.rank_value > self.rank_value:
		return -1
	if other.rank_value == self.rank_value:
		return -1 if other.suit_value > self.suit_value else 1
		# return 0
	return 1

extends Node2D

const SUITS = ["hearts", "clubs", "diamonds", "spades"]
const RANKS = {
	2: "02",
	3: "03",
	4: "04",
	5: "05",
	6: "06",
	7: "07",
	8: "08",
	9: "09",
	10: "10",
	11: "J",
	12: "Q",
	13: "K",
	14: "A",
}

const CARD_SCENE = preload("res://card.tscn")

var cards = []

func _init():
	# populate cards
	for rank_item in RANKS:
		for suit in SUITS:
			var rank_str = RANKS[rank_item]
			var card = CARD_SCENE.instantiate()
			card.initialize(rank_item, rank_str, suit)
			self.cards.push_back(card)

func shuffle():
	self.cards.shuffle()

func empty():
	return len(self.cards) == 0

func deal_top():
	return cards.pop_back()

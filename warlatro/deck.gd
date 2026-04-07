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

const CARD_SCENE = preload("res://card.tscn")

var cards = []

func _init():
	# populate cards
	for rank_item in RANKS:
		for suit in SUITS:
			var rank_str = RANKS[rank_item]
			var card = CARD_SCENE.instantiate()
			card.initialize(rank_str, suit)
			self.cards.push_back(card)

func shuffle():
	self.cards.shuffle()

func empty():
	return len(self.cards) == 0

func deal_top():
	return cards.pop_back()

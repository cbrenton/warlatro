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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flip():
	if self.is_flipped:
		queue_free()
	else:
		$Sprite2D.texture = self.texture
		self.is_flipped = true

func randomize():
	self.rank = RANKS[rng.randi_range(2, 14)]
	self.suit = SUITS[rng.randi_range(0, 3)]
	print("setting rank to %d and suit to %s", [self.rank, self.suit])

func initialize(rank = null, suit = null):
	if rank and suit:
		self.rank = rank
		self.suit = suit
	else:
		print("no rank or suit passed")
		self.randomize()

	var texture_path = "res://assets/cards/%s_of_%s.png" % [self.rank, self.suit]
	self.texture = load(texture_path)

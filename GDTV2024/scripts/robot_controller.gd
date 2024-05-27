extends Node2D

@onready var items = Items.new()

var item_types: Array
var rare_chance: float = 0.20 # chance for rare instead of common
var fav_chance : float = 0.40 # chance for specified item type
var loot: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	item_types = items.item_types #pull in the item dictionary
	print(item_types)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_loot(number: int, type: String = "NULL"):
	loot.clear()
	if type == "NULL":
		for i in number:
			var loot_type = item_types.pick_random()
			var rarity_type = "common"
			var rarity_chance = randf()
			if rarity_chance <= rare_chance:
				rarity_type = "rare"
			loot[i] = pick_item(loot_type,rarity_type)
		return loot
	else:
		for i in number:
			var ritem: float = randf()
			var loot_type: String = ""
			if ritem <= fav_chance:
				loot_type = type
			else:
				var remaining: Array = item_types.duplicate()
				remaining.erase(type)
				loot_type = remaining.pick_random()
			var rarity_type = "common"
			var rarity_chance = randf()
			if rarity_chance <= rare_chance:
				rarity_type = "rare"
			loot[i] = pick_item(loot_type, rarity_type)
		return loot
		

func pick_item(type,rarity):
	var picked: Dictionary
	if type == "weapon":
		if rarity == "common":
			picked = items.weapon_common[randi_range(0, items.weapon_common.size()-1)]
		if rarity == "rare":
			picked = items.weapon_rare[randi_range(0, items.weapon_rare.size()-1)]
	if type == "valuable":
		if rarity == "common":
			picked = items.valuable_common[randi_range(0, items.valuable_common.size()-1)]
		if rarity == "rare":
			picked = items.valuable_rare[randi_range(0, items.valuable_rare.size()-1)]
	if type == "med":
		if rarity == "common":
			picked = items.med_common[randi_range(0, items.med_common.size()-1)]
		if rarity == "rare":
			picked = items.med_rare[randi_range(0, items.med_rare.size()-1)]
	if type == "book":
		if rarity == "common":
			picked = items.book_common[randi_range(0, items.book_common.size()-1)]
		if rarity == "rare":
			picked = items.book_rare[randi_range(0, items.book_rare.size()-1)]
	if type == "food":
		if rarity == "common":
			picked = items.food_common[randi_range(0, items.food_common.size()-1)]
		if rarity == "rare":
			picked = items.food_rare[randi_range(0, items.food_rare.size()-1)]
	return picked

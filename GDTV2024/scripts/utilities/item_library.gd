extends Node
class_name Items

var item_types: Array = ["weapon","valuable","med","book","food"]

var weapon_common: Dictionary = {
	0:{
		"name": "Bat",
		"desc": "A run-of-the-mill Louisville Slugger.",
		"value": 25
	}
}
var weapon_rare: Dictionary = {
	0:{
		"name": "Gun",
		"desc": "a.k.a a rooty tooty point & shooty",
		"value": 400
	}
}

var valuable_common: Dictionary = {
	0:{
		"name": "Watch",
		"desc": "A classic wristwatch.",
		"value": 40
	}
}
var valuable_rare: Dictionary = {
	0:{
		"name": "Ring",
		"desc": "A simple band with a red gem",
		"value": 550
	}
}

var med_common: Dictionary = {
	0:{
		"name": "Bandages",
		"desc": "A comforting synthetic-cotton blend",
		"value": 10
	}
}
var med_rare: Dictionary = {
	0:{
		"name": "Drugs",
		"desc": "A pick-n-mix of various colorful capsules & tablets",
		"value": 250
	}
}
var book_common: Dictionary = {
	0:{
		"name": "Research Notes",
		"desc": "A pile of scribbled notes and annotated pages torn from various books",
		"value": 100
	}
}
var book_rare: Dictionary = {
	0:{
		"name": "Hardcover Book",
		"desc": "A fancy leather-bound tome on a very complicated subject.",
		"value": 300
	}
}
var food_common: Dictionary = {
	0:{
		"name": "Can of Soup",
		"desc": "100% of your daily recommended sodium intake.",
		"value": 60
	}
}
var food_rare: Dictionary = {
	0:{
		"name": "Unopened Fancy Lad Golden Sponge Cakes",
		"desc": "These cakes are one of the few treats left in this world.",
		"value": 350
	}
}

extends Control

@onready var day_count = $Datetime/Day
@onready var current_time = $Datetime/Time
@onready var money_amt = $Funds/LabelContainer/Money/MoneyAmt
@onready var resources_amt = $Funds/LabelContainer/Resources/ResourcesAmt
@onready var owed_amt = $Funds/LabelContainer/Owed/OwedAmt
@onready var broadcast_text = $Broadcast/BroadcastText
@onready var broadcast = $Broadcast
@onready var pause_screen = $PauseScreen
@onready var robot_inventory = $"../RobotInventory"
@onready var player_inventory = $"../PlayerInventory"
@onready var to_store_inventory = $"../ToStoreInventory"
@onready var upgrade_screen = $"../UpgradeScreen"
@onready var store = $".."
@onready var preferred_item_prompt = $"../PreferredItemPrompt"

@onready var player_controller = $"../PlayerController"


@export var scroll_speed: int = 500
var paused: bool = false
var player_items: Dictionary = {}


var day: int:
	set(day_num):
		day = day_num
		print("day was changed")
		day_count.text = "Day "+str(day)+","
var time: String:
	set(time_str):
		time = time_str
		print("time was changed")
		current_time.text = str(time)
var money: int:
	set(m_amt):
		money = m_amt
		print("money was changed")
		money_amt.text = str(money)
var resources: int:
	set(r_amt):
		resources = r_amt
		print("resouces was changed")
		resources_amt.text = str(resources)
var payed: int:
	set(p_amt):
		payed = p_amt
		print("payment was changed")
		owed_amt.text = str(payed)+'/'+str(total_owed)
var total_owed: int:
	set(total):
		total_owed = total
		print("total was changed")
		owed_amt.text = str(payed)+'/'+str(total_owed)
var announcment_type : String = ""

var weapon_announcements: Array = [
	"Attention survivors! This is a public service announcement: In these uncertain times, securing your safety is paramount. Arm yourself against the dangers that lurk the wasteland. Visit your nearest trading post and invest in reliable weaponry to protect yourself and your loved ones. Stay vigilant, stay armed, stay alive.",
	"To all resilient souls out there, listen up! As the remnants of society grapple with the aftermath of catastrophe, one thing remains clear: the need for self-defense. Don't fall prey to marauders or mutant threats. Equip yourself with the tools of survival. Seek out our reputable arms merchants and fortify your defenses. Remember, in this new world, the only guarantee is the strength you wield.",
	"Survivors, heed this warning! In the wake of societal collapse, the law of the land is no longer upheld. To safeguard your existence, it's imperative to arm yourself ! Visit your local dealer today.",
	"Hey there, fellow survivors! Feeling exposed in this harsh post-apocalyptic landscape? Look no further than NukiCorp for all your defensive needs! Our weapons are guaranteed to give you the edge over your adversaries, ensuring your survival and prosperity. Don't let the competition outgun you. Choose NukiCorp and seize control of your destiny. After all, in this world, it's every man for himself!",
	"Survivors, listen up! In this dog-eat-dog world, you need every advantage you can get. That's where NukiCorp comes in. Our weapons are unmatched in both quality and reliability, giving you the upper hand in any confrontation. Don't let your rivals outshine you. Invest in NukiCorp's arsenal today and show them who's boss. Remember, in this unforgiving reality, only the strong survive!"]
var valuable_announcements: Array = [
	"Attention survivors! In a world ravaged by chaos and uncertainty, it's more important than ever to hold onto the things that matter most. Show your love and appreciation for that special someone with a timeless gift from NukiCorp's exclusive collection of post-apocalyptic jewelry. Even amidst the rubble, let the sparkle of our finely crafted pieces remind you of the beauty that endures. Visit our nearest outpost and make a statement that transcends the apocalypse.",
	"Hey there, fellow wanderers! As we navigate the remnants of civilization, let's not forget the bonds that sustain us. Show your partner, friend, or family member just how much they mean to you with a unique piece of jewelry.",
	"Survivors, listen closely! In a world stripped bare by catastrophe, it's easy to lose sight of the beauty that remains. But amidst the chaos, love endures.",
	"To all resilient souls, the other day I found an old watch buried in the dirt and couldn't help but think of my father. I saw some robot combing through the sands and head towards that stand in the middle of nowhere. Maybe if you're thinking of family too, stop by and see if they have more?",
	"Til death do us part? It's more and more likely these days. There are all sorts of trinkets in the wasteland. If you can't find something lying in the dirt, maybe a local stall has found items to sell. Where do they get their stock anyway?"]
var meds_announcements: Array = [
	"Attention, fellow survivors! This is a PSA for anyone still out there scavenging for supplies. While food and water are undoubtedly important, don't forget about medications. Injuries and illnesses don't take a break just because the world has ended. So, make sure to prioritize gathering meds from every source you can find. Your health could depend on it.",
	"Hey everyone, listen up! This is a friendly reminder from your fellow survivors. With resources scarce and danger lurking around every corner, it's vital to be prepared. Don't forget to raid those abandoned pharmacies and hospitals for any meds you can find. I even saw some local stand selling premium brand-name stuff. You never know when you or someone you care about might need them. Stay vigilant, stay healthy.",
	"Hey there, fellow wasteland wanderers! In a world plagued by danger and uncertainty, your health is your most valuable asset. Don't risk being caught unprepared. Stock up on essential medications from NukiCorp's reliable inventory. From antiseptics to bandages, we have everything you need to stay healthy and resilient. Don't gamble with your well-being. Visit NukiCorp today and invest in your future.",
	"Attention survivors! In these turbulent times, maintaining your health is crucial for your survival. Don't leave your well-being to chance. Stock up on essential medications from NukiCorp's extensive pharmacy supplies. From antibiotics to painkillers, we've got you covered. Don't wait until it's too late. Visit our nearest outpost and secure your health today.",
	"Calling all survivors! As we navigate the remnants of civilization, remember that our health is our most precious asset. Don't overlook the importance of stocking up on medications. Whether it's antibiotics, painkillers, or antiseptics, gather what you can find. Trust me, in this new world, a well-stocked medicine cabinet could mean the difference between life and death."]
var book_announcements: Array = [
	"Attention, fellow wanderers! As we navigate the remnants of civilization, let's not forget the treasures that lie buried beneath the debris: the wealth of human knowledge. Books and research are not relics of a bygone era; they're the lifeblood of our collective wisdom. So let's dust off those shelves, revive those libraries, and reignite the flames of curiosity. In the pages of a book, we find not only solace but also strength. Let's harness that power to forge a new path forward, guided by the light of enlightenment.",
	"Survivors, gather 'round! In this world of chaos and uncertainty, let's not forget the power of knowledge to illuminate our path forward. Books are not just relics of the past; they're beacons of hope for our future. Whether it's learning new skills, uncovering forgotten technologies, or simply finding solace in the written word, let's embrace the positivity of books and research. So dust off those tomes, ignite your curiosity, and let's build a brighter tomorrow, one page at a time.",
	"Hey there, resilient souls! In the midst of the apocalypse, amidst the rubble and ruin, there's still something worth cherishing: the power of ideas. Books and research are our guiding lights in this darkened world. They offer us not only knowledge but also hope for a better tomorrow. So let's dive into the wisdom of the past, explore the possibilities of the present, and imagine the wonders of the future. In the pursuit of knowledge lies the path to redemption.",
	"Listen up! I realized the other day that I haven't read a single book since this all started. If you can get your hands on one, do not take it for granted. With everything going to hell, reading stories of other places not like here can help keep your sanity.",
	"Survivors, listen up! In a world stripped bare by catastrophe, books and research are the currency of progress. They hold the key to unlocking new horizons, discovering innovative solutions, and charting a course towards a brighter future. So let's celebrate the positivity of learning and exploration. Whether it's through scientific inquiry, literary escapades, or historical retrospection, let's embrace the transformative power of knowledge. Together, we can turn the page on the apocalypse and write a new story of resilience and renewal."]
var food_announcements: Array = [
	"Attention all survivors! This is a call to action in the face of scarcity. As we navigate this post-apocalyptic world, let's not underestimate the importance of sustenance. Food isn't just fuel for our bodies; it's a lifeline in these trying times.",
	"Hey there, resilient souls! As we brave the aftermath of disaster, let's not forget the most fundamental of needs: food. In a world where resources are scarce and survival is uncertain, nourishment is non-negotiable. ",
	"Attention, fellow survivors! In this harsh new reality, food isn't just a luxury; it's a necessity for survival. As we scavenge the ruins of civilization, let's keep our eyes peeled for any edible resources we can find. Whether it's canned goods in abandoned stores or edible plants in the wilderness, let's gather what we can to sustain ourselves.",
	"Survivors, are you tired of scavenging for scraps? Hungry for a solution to your food woes? Look no further than NukiCorp! Our innovative team has developed a range of post-apocalyptic food solutions to keep you nourished and energized in these challenging times. From nutrient-rich meal replacement bars to long-lasting canned goods, NukiCorp has you covered.",
	"Shop local! I saw this robot gathering canned goods outside of this stand in the middle of nowhere. If you're in need, head towards the only stand standing outside the city limits."]


# Called when the node enters the scene tree for the first time.
func _ready():
	day_count.text = 'Day '+str(day)+','
	current_time.text = time
	money_amt.text = str(money)
	resources_amt.text = str(resources)
	owed_amt.text = str(payed)+'/'+str(total_owed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if broadcast.visible && broadcast_text.position.x > -broadcast_text.size.x && !paused:
		broadcast_text.position.x = lerp(broadcast_text.position.x,broadcast_text.position.x - scroll_speed * delta,0.25 )
	if broadcast.visible && broadcast_text.position.x <= -broadcast_text.size.x:
		broadcast.visible = false
		#TODO: fix jitter & account for text longer than the textbox size

func _input(event):
	#putting this here so we can set HUD to Always process and leave Store at Inherit
	#this lets us unpause after pausing (theoretically)
	#TODO: figure out why pause doesn't pause announcement scroll despite Broadcast & children being set to pausable
	if event.is_action_pressed("ui_cancel") and (robot_inventory.visible == false and player_inventory.visible == false):
		SceneManager.PauseGame()
		if pause_screen.visible:
			paused = false
			pause_screen.visible = false
		else:
			pause_screen.visible = true
			paused = true
	
func select_announcement(type):
	if type == "weapon":
		broadcast_text.text = weapon_announcements.pick_random()
	elif type == "valuable":
		broadcast_text.text = valuable_announcements.pick_random()
	elif type == "med":
		broadcast_text.text = meds_announcements.pick_random()
	elif type == "book":
		broadcast_text.text = book_announcements.pick_random()
	elif type == "food":
		broadcast_text.text = food_announcements.pick_random()
	else:
		broadcast_text.text = "ERROR: INCORRECT TYPE PASSED"
		print("ERROR: INCORRECT TYPE PASSED")
	broadcast.visible = true

func change_value(change_type,amt):
	if change_type == "total":
		total_owed = amt
	if change_type == "payment":
		payed += amt
	if change_type == "money":
		money += amt
	if change_type == "resources":
		resources += amt
	if change_type == "day":
		day += amt
	if change_type == "time":
		time = amt


func _on_inventory_button_pressed():
	store.send_item_list()


func _on_upgrades_button_pressed():
	upgrade_screen.show_upgrades()


func _on_open_button_pressed():
	#store.afternoon_phase()
	if store.time == store.times[0]:
		store.afternoon_phase()
	elif store.time == store.times[1]:
		store.evening_phase()
	elif store.time == store.times[2]:
		if store.item_pref != "":
			preferred_item_prompt.visible = false
			store.morning_phase()

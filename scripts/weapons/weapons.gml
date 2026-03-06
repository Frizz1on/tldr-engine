
// swords
function item_w_spookyswordb() : item_weapon() constructor {
	name = ["Spookysword"]
	desc = ["A black-and-orange sword with a bat hilt.", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		attack: 2, 
		defense:1

	}
	effect = {
        text: "Spookiness UP",
        sprite: spr_ui_menu_icon_up
    }
	icon = spr_ui_menu_icon_sword
	
	weapon_whitelist = ["ralsei"]
	
	reactions = {
		kris: "swords arent really my style",
		susie: "Isn't this Kris's sword?",
		ralsei: "Perfect for Krismas!",
        noelle: "If only"
	}
    
    buy_price = 200
    sell_price = 100
    
}
function item_w_marblesword() : item_weapon() constructor {
	name = ["Marblade"]
	desc = ["A sword made of marble. The pattern of an eye is etched along the blade", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		attack: 3, 
		defense:1

	}
	
	weapon_whitelist = ["ralsei"]
	
	reactions = {
		kris: "Why is it watching me",
		susie: "Who carved the eye?.",
		ralsei: "My battle tendancies.",
        noelle: "How strong een is marble?"
	}
    
    buy_price = 200
    sell_price = 100
    
}

function item_w_chainedsword() : item_weapon() constructor {
	name = ["K-Gama"]
	desc = ["A large chain with a blade attached to the end, impractical for defending", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		attack: 5, 
		defense:-2

	}
	
	weapon_whitelist = ["ralsei"]
	
	reactions = {
		kris: "What in the world is this?",
		susie: "That guy dropped this..",
		ralsei: "You swing it like this!",
        noelle: "Carry me along river styx?"
	}
    
    buy_price = 200
    sell_price = 100
    
}

// guns
function item_w_sgun() : item_weapon() constructor {
	name = ["Wild Wester"]
	desc = ["A small blaster made for a true sheriff", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		attack: 3, 
		defense:0

	}
	
	weapon_whitelist = ["kris"]
	
	reactions = {
		kris: "I guess this is mine",
		susie: "I'd rather not.",
		ralsei: "I'll stick to swords",
        noelle: "No room in this town for me"
	}
    
    buy_price = 200
    sell_price = 100
    
}
function item_w_bigiron() : item_weapon() constructor {
	name = ["Big Iron"]
	desc = ["A blaster that smells of greese and bacon", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		attack: 5, 
		defense:0

	}
	
	weapon_whitelist = ["kris"]
	
	reactions = {
		kris: "Justice best served hot!",
		susie: "Fry them reggie!",
		ralsei: "Do I smell food?",
        noelle: "Who comes up with these"
	}
    
    buy_price = 200
    sell_price = 100
    
}
// magic items
function item_magglove() : item_weapon() constructor {
	name = ["Magicians glove"]
	desc = ["A pair of leather gloves fit for any magician", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		magic: 3, 
		defense:-1

	}
	
	weapon_whitelist = ["susie"]
	
	reactions = {
		kris: "Not for me.",
		susie: "It makes my magic stronger.",
		ralsei: "This belongs to Amari",
        noelle: "Ihave my own magic item"
	}
    
    buy_price = 200
    sell_price = 100
    
}
function item_agstaff() : item_weapon() constructor {
	name = ["Agstaff"]
	desc = ["A broken magic staff still hold a big of power", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		magic: 3, 
		defense:-1

	}
	
	weapon_whitelist = ["susie"]
	
	reactions = {
		kris: "What is this?.",
		susie: "I guess i can use this...",
		ralsei: "I'm a wizard!",
        noelle: "it's broken"
	}
    
    buy_price = 200
    sell_price = 100
    
}

function item_gagstaff() : item_weapon() constructor {
	name = ["Great Barrier Agstaff"]
	desc = ["The greatest magic staff, forged from the breath of the frost dragon", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		magic: 20, 
		defense:12,
		attack:6

	}
	
	weapon_whitelist = ["susie"]
	
	reactions = {
		kris: "What power.",
		susie: "such a powerful item , this is for me?.",
		ralsei: "The perfect gift.",
        noelle: "Wait it was repaired?"
	}
    
    buy_price = 2000
    sell_price = 1000
    
}
function item_karma() : item_weapon() constructor {
	name = ["Karma"]
	desc = ["A Large greatsword eternally bound to its user.", "--"]
	lw_counterpart = item_w_lw_halloween_pencil
    
	stats = {
		magic: 4, 
		defense:4,
		attack:4

	}
	
	weapon_whitelist = ["noelle"]
	
	reactions = {
		kris: "Where does he even put this?.",
		susie: "Slip and fall.",
		ralsei: "WAAAAY to big for me to swing.",
        noelle: "that's mine..."
	}
    
    buy_price = 0
    sell_price = 0
    
}
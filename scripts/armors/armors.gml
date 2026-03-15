function item_a_dual_ribbon() : item_armor() constructor {
	name = ["Twin Ribbon"]
	desc = ["Two ribbons. You'll have to put\nyour hair into pigtails.", "--"]
	
	armor_blacklist = ["kris"]
	
	stats = {
		defense: 3,
	}
	effect = {
        text: "GrazeArea",
        sprite: spr_ui_menu_icon_up
    }
	
	reactions = {
		kris: "Don't have much hair to tie this around.",
		susie: "Brings me back",
		ralsei: "So pretty",
		noelle: "How do you tie pigtails?",
	}
    
    sell_price = 200
}
function item_a_grey_rook() : item_armor() constructor {
	name = ["Grey Rook"]
	desc = ["A marble statuette, seems to enhance your defense", "--"]
	
	stats = {
		defense: 5,
		attack: 2
	}
	
	reactions = {
		kris: "How in the world do I equip this?.",
		susie: "Do I just hold it?",
		ralsei: "What am I supposed to do with this?",
		noelle: "Rook to F3",
	}
    
    sell_price = 200
}
function item_a_angel_sigil() : item_armor() constructor {
	name = ["Angel Sigil"]
	desc = ["A charm that represents an angel", "--"]
	armor_blacklist = ["noelle"]
	
	stats = {
		defense: 2,
		magic: 3
	}
	
	reactions = {
		kris: "We found it.",
		susie: "Who is she?",
		ralsei: "What even is this?.",
		noelle: "...",
	}
    
    sell_price = 200
}

function item_a_kanon_fragment() : item_armor() constructor {
	name = ["Bloody Thorn"]
	desc = ["A sharp bloody thorn found in a dumpster", "--"]
	armor_blacklist = ["kris", "susie", "ralsei", "noelle" ]
	
	stats = {
		defense: -2,
		magic: -2,
		attack: 4
	}
	
	reactions = {
		kris: "Dawg what",
		susie: "Can we throw this back?",
		ralsei: "Not putting that on",
		noelle: "Thats just nasty",
	}
    
    sell_price = -224
}





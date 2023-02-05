extends Node
class_name Chemistry
var reagents: Array
var reactions: Array

class Reagent:
	extends Object
	var id: String
	var name: String
	var desc: String
	var physical_desc: String
	var color: Color
	
	func _init(reagent_id: String, reagent_name: String, reagent_desc: String, reagent_physic_desc: String, reagent_color: Color):
		id = reagent_id
		name = tr(reagent_name)
		desc = tr(reagent_desc)
		physical_desc = tr(reagent_physic_desc)
		color = reagent_color

class Reaction:
	extends Object
	var reagents: Array
	var catalysts: Array
	var products: Array
	
	func _init(reaction_reagents: Array, reaction_catalysts: Array, reaction_products: Array):
		reagents = reaction_reagents
		catalysts = reaction_catalysts
		products = reaction_products
		

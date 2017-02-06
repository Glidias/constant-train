package cstrain.vuex.game;
import cstrain.core.Card;
import cstrain.core.IRules;

/**
 * Vue model
 * @author Glidias
 */
class GameState
{
	// exposed propties for Vue model
	public var cards:Array<Card>;
	public var popup:PopupConstantModel = null;
	
	// internal properties to be injected later to avoid Vuex reactivity
	public var _rules:IRules;
	

	public function new(rules:IRules) 
	{
		this.cards = rules.getAllCards();
		
		
	}
	
}

typedef PopupConstantModel = {
	var value1:Float;
	var value2:Float;
}
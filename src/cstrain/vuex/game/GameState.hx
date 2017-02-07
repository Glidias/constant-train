package cstrain.vuex.game;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.core.IRules;
import cstrain.core.Polynomial;

/**
 * Vue model
 * @author Glidias
 */
class GameState
{
	// exposed viewmodel properties
	public var cards:Array<Card>;
	public var topCard:Card = null;
	public var delayTimeLeft:Float = 0;
	public var isPopup:Bool = false;
	public var cardResult:CardResult= null;
	public var polynomial:Polynomial = null;
	public var showExpression:Bool = false;
	
	// internal properties to be injected later to avoid Vuex vuemodel reactivity
	public var _rules:IRules;
	
	

	public function new(rules:IRules) 
	{
		this.cards = rules.getAllCards();
		
		
	}
	
}


package cstrain.rules;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.core.Deck;
import cstrain.core.IRules;
import cstrain.core.Polynomial;

/**
 * Game model for specific rule set
 * @author Glidias
 */
class TestGame implements IRules
{
	var polynomial:Polynomial;
	var deck:Deck;
	
	
	var curDeck:Deck;
	var curDeckIndex:Int;

	public function new() 
	{
		restart();
	}
	
	function buildDeck():Void {
		deck.addCards( Deck.getCards(Deck.MASK_NUMBER_ALL, 0, 0, 1) );
		deck.addCards( Deck.getCards(Deck.SET_VARIABLE, Deck.OP_ADD | Deck.OP_SUBTRACT, 0, 4) );
		deck.addCards( Deck.getCards(Deck.SET_VARIABLE, Deck.OP_MULTIPLY | Deck.OP_DIVIDE, 0, 2) );

		deck.shuffle();
		
		// playdeck reference
		curDeck = deck;
		curDeckIndex = curDeck.cards.length - 1;
	
	}
	
	function getFakeValueOf(val:Float):Float {
		return val;
	}
	
	
	
	/* INTERFACE cstrain.core.IRules */
	
	public function restart():Void {
		deck  = new Deck();
		polynomial = new Polynomial();
		buildDeck();
	}
	
	public function getAllCards():Array<Card> {
		return deck.cards;
	}
	
	
	public function playCard(isSwipeRight:Bool):CardResult {
		var curCard:Card = curDeckIndex > 0 ? curDeck.cards[curDeckIndex--] : null;
		if (curCard == null) return null;
		
		polynomial.performOperation( Card.toOperation(curCard) );
		if (isSwipeRight) {
			if (isConstant()) {
				// Ok, good, show pop quiz
				return Math.random() >= .5 ? CardResult.GUESS_CONSTANT(polynomial.constantInteger, getFakeValueOf(polynomial.constantValue) ) :
											CardResult.GUESS_CONSTANT( getFakeValueOf(polynomial.constantValue), polynomial.constantInteger );
			}
			else {
				// penalized, stopped in mdidle of nowhere, are you lost?
				return CardResult.PENALIZE({});
			}
		}
		else {
			if (isConstant()) {
				// // penalize missed stop
				return CardResult.PENALIZE({});
			}
			else {
				// ok , continue as per normal
				return CardResult.OK;
			}
		}
		
		return CardResult.NOTHING;
	}
	
	

	
	public function getTopmostCard():Card 
	{
		return curDeck.cards[curDeckIndex];
	}
	public function getNextCardBelow():Card 
	{
		return curDeckIndex > 0 ? curDeck.cards[curDeckIndex-1] : null;
	}
	
	
	public inline function isConstant():Bool 
	{
		return !polynomial.isUnknown;
	}
	
	
	
}
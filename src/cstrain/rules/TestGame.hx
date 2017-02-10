package cstrain.rules;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.core.Deck;
import cstrain.core.IRules;
import cstrain.core.PenaltyDesc;
import cstrain.core.Polynomial;

/**
 * Example game setup
 * @author Glidias
 */
class TestGame implements IRules
{
	// value state
	var polynomial:Polynomial;
	
	// card state
	var deck:Deck;
	var thePopupCard:Card;
	
	// cur card state
	var curDeck:Deck;
	var curDeckIndex:Int;
	var wildGuess:Bool;  // having a stateful flag like this is not ideal..
	
	var secretVarValue:Int;
	var polynomialValue:Int;
	var polynomialValueCached:Bool = false;
	inline function recreateSecret():Void {
		secretVarValue = Std.int( Math.ceil( Math.random() * 10 ) );
		polynomialValueCached = false;
	}
	inline function getSecretValue():Int {
		return polynomialValueCached ? polynomialValue : (polynomialValue=getPolynomialValue(secretVarValue));
	}

	public function new() 
	{
		restart();
	}
	
	function buildDeck():Void {
		var baseMult:Int   = 8;
		deck.addCards( Deck.getCards(Deck.SET_NUMBERS, Deck.OP_ADD | Deck.OP_SUBTRACT, 0, 1*baseMult) );
		deck.addCards( Deck.getCards(Deck.SET_NUMBERS, Deck.OP_MULTIPLY | Deck.OP_DIVIDE ,  Deck.NUM_2, 1*baseMult) );

		deck.addCards( Deck.getCards(Deck.SET_VARIABLE, Deck.OP_ADD, 0, 8*baseMult - 1) );
		deck.addCards( Deck.getCards(Deck.SET_VARIABLE, Deck.OP_SUBTRACT, 0, 8*baseMult) );
		deck.addCards( Deck.getCards(Deck.SET_VARIABLE, Deck.OP_MULTIPLY | Deck.OP_DIVIDE, 0, 4*baseMult) );

		deck.shuffle();
		
		// playdeck reference
		curDeck = deck;
		curDeckIndex = curDeck.cards.length - 1;
		
		
		thePopupCard = Card.getRegularStartingVarCard();
	}
	
	function getFakeValueOf(val:Float):Int {
		var ceil:Int = Math.ceil(val / 20);
		if (ceil == 0) ceil = 1;
		var magnitudeBase:Float = ceil * 20;
		var minBase:Int =Std.int(Math.ceil( magnitudeBase/8));
		return Math.random() >= .5 ? Std.int( val -minBase - Std.int(magnitudeBase*Math.random()) ) : Std.int( val + minBase + Std.int(magnitudeBase*Math.random()) );
	}
	
	function getCloserValueTo(val:Float, from:Int):Int {
		var amt:Float = val - from;
		from += val >= from ? Std.int(Math.ceil( Math.random() * amt )) :Std.int( Math.floor(Math.random() * amt));
		return from;
	}
	
	function getFakeValueOfCloserValue(val:Float):Int {
		var ceil:Int = Math.ceil(val / 20);
		if (ceil == 0) ceil = 1;
		var magnitudeBase:Float = ceil * 20;
		var minBase:Int = Std.int(Math.ceil( magnitudeBase/2));
		return Math.random() >= .5 ? Std.int( val -minBase - Std.int(magnitudeBase*Math.random()) ) : Std.int( val + minBase + Std.int(magnitudeBase*Math.random()) );
	}
	
	
	
	function getCardResult(isSwipeRight:Bool):CardResult {
		var curCard:Card =thePopupCard != null ? thePopupCard :  curDeckIndex >= 0 ? curDeck.cards[curDeckIndex--] : null;
		if (curCard == null) {
			return CardResult.GAMEOVER_OUTTA_CARDS;
		}

		thePopupCard = null;	// assume for this set of rules, popup card is always cleared
		
		
		if (Card.canOperate(curCard.operator)) {  // handle regular operator stuffz
			
			polynomial.performOperation( Card.toOperation(curCard) );

			if (isSwipeRight) {
				if (isConstant()) {
					// Ok, good, show pop quiz
					var fakeVal:Int = getFakeValueOf(polynomial.constantInteger);
					var result:Int = polynomial.constantInteger;
					trace(fakeVal + ", " + result);
					return Math.random() >= .5 ? CardResult.GUESS_CONSTANT( Card.getRegularGuessConstantCard(result, fakeVal), false ) :
												CardResult.GUESS_CONSTANT( Card.getRegularGuessConstantCard(fakeVal, result), false );
				}
				else {
					// penalized, stopped in mdidle of nowhere, are you lost? Delay train.
					// or guess var value result as it currently is, once solved, can continue, must var will be re-scrambled
					
					// or force pop quiz of unknown value?
					return CardResult.PENALIZE({ desc:PenaltyDesc.LOST_IN_TRANSIT, delayNow:2 });
				}
			}
			else {
				if (isConstant()) {
					// // penalize missed stop,
					
					// guess var value result as it currently is (else, if guessing constant ala reverse to constant station, MUST undo the polynomial operation)
					return CardResult.PENALIZE({ desc:PenaltyDesc.MISSED_STOP, delayNow:2  });
				}
				else {
					// ok , continue as per normal
					return CardResult.OK;
				}
			}
			trace("UNaccounted operation");
		}
		else {	  // handle non-operator stuffz
			//trace("NON OPERATOR:");
			if (curCard.operator == Card.OPERATION_EQUAL) {
				
				var c = !wildGuess ? getConstant() : getSecretValue();  // guess var result for wildGuessing
				var rightIsRight:Bool = wildGuess ?  Math.abs(curCard.virtualRight.value - c) < Math.abs(curCard.value -c ) : curCard.virtualRight.value == c;
				var valueChosen:Int = isSwipeRight ? curCard.virtualRight.value : curCard.value;
				_valueChosen = valueChosen; //scratch variable
				if ( (isSwipeRight && rightIsRight) || (!isSwipeRight && !rightIsRight  )) {
					if (c != valueChosen) {
						if (!wildGuess) {
							trace("Should not happen exception occured mismatch with swipe and correct answre for !wildGuess..");
						}
						return  CardResult.PENALIZE({desc:PenaltyDesc.CLOSER_GUESS(c> valueChosen) , delayNow:1});
					}
					else {
						// Got the answer correct, now, moving out train again!
						thePopupCard = Card.getRegularStartingVarCard();
						recreateSecret();
						
						return CardResult.OK;
					}
				}
				else {	// gave not so good answer...
					return !wildGuess ? CardResult.PENALIZE({desc:WRONG_CONSTANT, delayNow:1}) :  CardResult.PENALIZE({delayNow:2, desc:PenaltyDesc.FURTHER_GUESS( c>valueChosen)  });
				}
				
				
			}
			else {
				trace("Unaccounted for opreation: " + Card.stringifyOp(curCard.operator));
			}
		}
		
		trace("Exception CardResult.NOTHING detected. Should not happen!");
		return CardResult.NOTHING;
	}
	
	var _valueChosen:Int;
	
	inline function getConstant():Int {
		return polynomial.constantInteger;
	}
	inline function getPolynomialValue(varValue:Int):Int {
		return polynomial.evalValueInt(varValue);
	}
	
		
	inline function isConstant():Bool 
	{
		return !polynomial.isUnknown;
	}
	
	/* INTERFACE cstrain.core.IRules */
	
	public function restart():Void {
		deck  = new Deck();
		thePopupCard = null;
		polynomial = new Polynomial();
		wildGuess = false;
		recreateSecret();
		
		
		buildDeck();
		
	}
	
	public function getAllCards():Array<Card> { 
		return deck.cards;
	}

	
	public function playCard(isSwipeRight:Bool):CardResult {
		var result = getCardResult(isSwipeRight);
		
		switch( result ) {
			case CardResult.GUESS_CONSTANT(guessConstantCard, wildGuess):
				this.wildGuess = wildGuess;
				var c = getConstant();
				thePopupCard = guessConstantCard;
				
			case CardResult.PENALIZE({desc:PenaltyDesc.MISSED_STOP}):
				wildGuess = true;  // just a convention, whether popup quiz shows up or not
				var val = getSecretValue();
				val = getFakeValueOf(val);
				thePopupCard = Card.getRegularGuessConstantCard( val,  getFakeValueOfCloserValue(val) );
			case CardResult.PENALIZE({desc:PenaltyDesc.LOST_IN_TRANSIT}):
				wildGuess = true;
			case CardResult.PENALIZE({desc:PenaltyDesc.CLOSER_GUESS(_)}) | CardResult.PENALIZE({desc:PenaltyDesc.FURTHER_GUESS(_)}):
	
				var v= wildGuess ? getSecretValue() : getConstant();
				var to = getSecretValue();
				var firstChoice = getCloserValueTo(v, _valueChosen );
				var secondChoice = getCloserValueTo(v, _valueChosen);
				if (secondChoice == firstChoice) {
					secondChoice = getFakeValueOfCloserValue(firstChoice);  // whateer, need to look into this latter
				}
				thePopupCard = Card.getRegularGuessConstantCard(firstChoice, secondChoice); 

			//case CardResult.OK:
			//	wildGuess = false;
				
			default:
		}
		return result;
	}
	
	inline function getTopCard():Card {
		return curDeckIndex >= 0 ? curDeck.cards[curDeckIndex] : null;
	}
	inline function getBelowCardCard():Card {
		return curDeckIndex >= 1 ? curDeck.cards[curDeckIndex-1] : null;
	}

	public function getTopmostCard():Card 
	{
		return thePopupCard != null ? thePopupCard : getTopCard();
	}
	public function getNextCardBelow():Card 
	{
		return thePopupCard != null ?  getTopCard() : getBelowCardCard();
	}
	
	public function getPolynomial():Polynomial 
	{
		return polynomial;
	}

	
}
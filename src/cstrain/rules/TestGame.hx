package cstrain.rules;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.core.Deck;
import cstrain.core.GameSettings;
import cstrain.core.IRules;
import cstrain.core.PenaltyDesc;
import cstrain.core.PlayerStats;
import cstrain.core.Polynomial;
import cstrain.util.FastRNG;
import haxe.Timer;

/**
 * Example game setup
 * @author Glidias
 */
class TestGame implements IRules
{
	// value state
	var polynomial:Polynomial;
	
	var currentPlayerStats:PlayerStats;
	
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
	
	var gameSettings:GameSettings = new GameSettings();
	
	var rng:FastRNG;
	
	inline function recreateSecret():Void {
		secretVarValue = Std.int( Math.ceil( Math.random() * 10 ) );
		polynomialValueCached = false;
	}
	inline function getSecretValue():Int {
		return polynomialValueCached ? polynomialValue : (polynomialValue=getPolynomialValue(secretVarValue));
	}
	
	

	public function new() 
	{
		gameSettings.penaltyDelayMs =2000;
		
	
	}
	
	function buildDeck():Void {
		var baseMult:Int   = 1;
		deck.addCards( Deck.getCards(Deck.SET_NUMBERS, Deck.OP_ADD | Deck.OP_SUBTRACT, 0, 1*baseMult) );
		deck.addCards( Deck.getCards(Deck.SET_NUMBERS, Deck.OP_MULTIPLY | Deck.OP_DIVIDE ,  Deck.NUM_2, 1*baseMult) );

		deck.addCards( Deck.getCards(Deck.SET_VARIABLE, Deck.OP_ADD, 0, 8*baseMult - 1) );
		deck.addCards( Deck.getCards(Deck.SET_VARIABLE, Deck.OP_SUBTRACT, 0, 8*baseMult) );
		deck.addCards( Deck.getCards(Deck.SET_VARIABLE, Deck.OP_MULTIPLY | Deck.OP_DIVIDE, 0, 4*baseMult) );

		deck.shuffle(rng);
		
		// playdeck reference
		curDeck = deck;
		curDeckIndex = curDeck.cards.length - 1;
		
		
		thePopupCard = Card.getRegularStartingVarCard();
	}
	
	function getFakeValueOf(val:Float):Int {
		var ceilVal:Int = Math.ceil(val / 20);
		if (ceilVal == 0) ceilVal = 1;
		var magnitudeBase:Float =ceilVal  * 20;
		var minBase:Int =Std.int(Math.ceil( magnitudeBase/8));
		return Math.random() >= .5 ? Std.int( val -minBase - Std.int(magnitudeBase*Math.random()) ) : Std.int( val + minBase + Std.int(magnitudeBase*Math.random()) );
	}
	
	function getCloserValueTo(val:Float, from:Int):Int {
		var amt:Float = val - from;
		from += val >= from ? Std.int(Math.ceil( Math.random() * amt )) :Std.int( Math.floor(Math.random() * amt));
		return from;
	}
	
	function getFakeValueOfCloserValue(val:Float):Int {
		var ceilVal:Int = Math.ceil(val / 20);
		if (ceilVal == 0) ceilVal = 1;
		var magnitudeBase:Float = ceilVal * 20;
		var minBase:Int = Std.int(Math.ceil( magnitudeBase/2));
		return Math.random() >= .5 ? Std.int( val -minBase - Std.int(Math.floor((magnitudeBase*Math.random())) ) ) : Std.int( val + minBase + Std.int( Math.ceil(magnitudeBase*Math.random())) );
	}
	
	
	
	function getCardResult(isSwipeRight:Bool):CardResult {
		var hadPopupCard:Bool   = thePopupCard != null;
		var curCard:Card = null;
		if (hadPopupCard) {
			curCard = thePopupCard;
		}
		else {
			curCard = curDeckIndex >= 0 ? curDeck.cards[curDeckIndex] : null;
			curDeckIndex--;
		}
		
		if (curCard == null) {
			return CardResult.GAMEOVER_OUTTA_CARDS;
		}
		
		thePopupCard = null;	// assume for this set of rules, popup card is always cleared
		
		
		if (Card.canOperate(curCard.operator)) {  // handle regular operator stuffz
			
			
			polynomial.performOperation( Card.toOperation(curCard) );
			currentPlayerStats.lastMovedTime = Date.now().getTime();
			
			if (isSwipeRight) {
				if (isConstant()) {
					// Ok, good, show pop quiz
					return Math.random() >= .5 ? CardResult.GUESS_CONSTANT( Card.getRegularGuessConstantCard( polynomial.constantInteger, getFakeValueOf(polynomial.constantValue)), false ) :
												CardResult.GUESS_CONSTANT( Card.getRegularGuessConstantCard( getFakeValueOf(polynomial.constantValue), polynomial.constantInteger), false );
				}
				else {
					// penalized, stopped in mdidle of nowhere, are you lost? Delay train.
					// or guess var value result as it currently is, once solved, can continue, must var will be re-scrambled
					
					// or force pop quiz of unknown value?
					return CardResult.PENALIZE({ desc:PenaltyDesc.LOST_IN_TRANSIT, delayNow:0.75 });
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
					return CardResult.OK(hadPopupCard  ? 0 :1);
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
						return CardResult.OK(0);
					}
				}
				else {	// gave not so good answer...
					if (!wildGuess) {
						thePopupCard = Card.getRegularStartingVarCard();
						return  CardResult.PENALIZE({desc:WRONG_CONSTANT, delayNow:1});
					}
					else {
						return CardResult.PENALIZE({delayNow:2, desc:PenaltyDesc.FURTHER_GUESS( c>valueChosen)  });
					}
				
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
	
	var commenced:Bool = false;
	/* INTERFACE cstrain.core.IRules */
	
	public function restart(?seed:Int):Void {
		if (seed == null) seed = FastRNG.newSeed(); 
		
		// test cases
		//367925706;
		//22110498
		//seed = 367925706;
		
		#if !production
		trace(seed);
		#end
		
		rng = new FastRNG(seed);
		
		deck  = new Deck();
		thePopupCard = null;
		polynomial = new Polynomial();
		wildGuess = false;
		recreateSecret();
		_lastReceivedTime = 0;
		_penaltyTime = 0;
		
		
		commenced = false;
		currentPlayerStats = new PlayerStats();
		buildDeck();
		
	}
	
	public function getAllCards():Array<Card> { 
		var c =  deck.cards.concat([]);
		c.reverse();
		return c;
	}

	
	var _penaltyTime:Float;
	
	public function playCard(isSwipeRight:Bool):CardResult {
		
		var currentTime:Float = Timer.stamp() * 1000;// Date.now().getTime();
		var timeCap:Float  = ( _penaltyTime >= gameSettings.minTurnTime ? _penaltyTime : gameSettings.minTurnTime );
		if (currentTime - _lastReceivedTime < timeCap ) return CardResult.NOT_YET_AVAILABLE( timeCap-(currentTime - _lastReceivedTime) , _penaltyTime);
		
		
		// factor this out elsewhere as one hook
		var result = getCardResult(isSwipeRight);
		
		switch( result ) {
			case CardResult.GUESS_CONSTANT(guessConstantCard, wildGuess):
				this.wildGuess = wildGuess;
				var c = getConstant();
				thePopupCard = guessConstantCard;
				currentPlayerStats.reachedStops++;
			case CardResult.PENALIZE({desc:PenaltyDesc.LOST_IN_TRANSIT}):
				wildGuess = true;
				currentPlayerStats.lostInTransits++;
			case CardResult.PENALIZE({desc:PenaltyDesc.MISSED_STOP}):
				wildGuess = true;  // just a convention, whether popup quiz shows up or not
				var to = getSecretValue();
				if (to != polynomial.constantInteger) {
					trace("Assertion failed values mismatched between secret and constant at constant station!:" + [to, polynomial.constantInteger] );
				}
				var firstChoice = getFakeValueOf(to);
				var secondChoice = getFakeValueOf(to);
				if (secondChoice == firstChoice) {
					secondChoice = getFakeValueOfCloserValue(firstChoice);
				}
				thePopupCard = Card.getRegularGuessConstantCard(firstChoice, secondChoice); 
				
				currentPlayerStats.missedStops++;
			case CardResult.PENALIZE({desc:PenaltyDesc.CLOSER_GUESS(_)}) | CardResult.PENALIZE({desc:PenaltyDesc.FURTHER_GUESS(_)}):
	
				var v= wildGuess ? getSecretValue() : getConstant();
				var to = getSecretValue();
				var firstChoice = getCloserValueTo(v, _valueChosen );
				var secondChoice = getCloserValueTo(v, _valueChosen);
				if (secondChoice == firstChoice) {
					secondChoice = getFakeValueOfCloserValue(firstChoice);  // whateer, need to look into this latter to further improve guessability
				}
				thePopupCard = Card.getRegularGuessConstantCard(firstChoice, secondChoice); 
				
			default:
		}
		
		
		switch ( result) {
			case CardResult.PENALIZE(penalty):
				if (penalty.delayNow != null){
					_penaltyTime = penalty.delayNow * gameSettings.penaltyDelayMs;
				}
			default:
				_penaltyTime  = 0;
		}
		
		_lastReceivedTime = currentTime;
		return result;
	}
	
	private var _lastReceivedTime:Float = 0;
	
	inline function getTopCard():Card {
		return curDeckIndex >= 0 ? curDeck.cards[curDeckIndex] : null;
	}
	inline function getBelowCardCard():Card {
		return curDeckIndex >= 1 ? curDeck.cards[curDeckIndex-1] : null;
	}

	public function getPlayerStats():PlayerStats {
		return currentPlayerStats; //   .clone();
	}
	public function getGameSettings():GameSettings {
		return gameSettings; //   .clone();
	}
	public function getTopmostCard():Card 
	{
		if (!commenced) {
			commenced = true;
			currentPlayerStats.startTime = Timer.stamp() * 1000;// Date.now().getTime();
		}
		return thePopupCard != null ? thePopupCard : getTopCard();
	}
	
	private var _lastResultTest:Polynomial;
	
	private function pickAFactor(factors:Array<Polynomial>):Polynomial {
		// Convention, pick factor of highest length to act as divisor? Or just random with factorisation seed...?
		var candidates:Array<Polynomial> = [];
		for ( i in 0...factors.length) {
			var f:Polynomial = factors[i];
			if ( f.coefs.length > 1) {
					candidates.push(f);
			}
		}
		return candidates.length != 0 ? candidates[Std.int(rng.getFloat() * candidates.length)] : factors[Std.int(rng.getFloat() * factors.length)];
		
	}
	
	
	
	public function arrPolynomialNot1(poly:Polynomial):Bool {
		return poly.coefs.length  >  1  || Math.abs(poly.coefs[0]) != 1;
	}
	
	public function getNextCardBelow():Card 
	{
		
		var result:Card = thePopupCard != null ?  getTopCard() : getBelowCardCard();
		if (result == null) return null;
		if ( thePopupCard == null && result.operator == Card.OPERATOR_DIVIDE && result.varValues == null ) {  
			trace("To process card to polynomial");
			// check if division is possible and modify card if necessary
			var topCard:Card = getTopCard();
			var simulateTopResult:Polynomial;
			if (Card.canOperate(topCard.operator)) {
				simulateTopResult = polynomial.performOperationImmutable( Card.toOperation(topCard) );
				_lastResultTest = simulateTopResult;
			}
			else {
				trace("Unforeseen card expected operatable for getNextCardBelow()");
				simulateTopResult = polynomial.clone();
			}
			trace("Considering simulated result:" + simulateTopResult);
			
			if ( result.isVar ) {	// variable x division case
				// check factorisable
				if (simulateTopResult.coefs[0] == 0) {	// trivial case no need factorisation
					result.setPolynomial( Polynomial.fromCoefs([0, result.value]));
					
					return result;
				}
				else {
					
					var factors = simulateTopResult.factorisation();
					factors = factors.filter(arrPolynomialNot1);
					if (factors.length > 1 ) {
						var vFactor:Polynomial  = pickAFactor(factors);
						result.setPolynomial(vFactor);
						
					}
					else {
						// perform alternative for result  (deriative or divide-see-quotient-only)
						// if no polynomail used for division, then it would be a divide see quotient only operation
						result.operator = Card.OPERATOR_QUOTIENT;
						result.setPolynomial(Polynomial.fromCoefs([0, result.value ]) );
						// else use deriative operation
					}
					return result;
				}
				
			}
			else {	// Non-variable division case
				var cf:Int = simulateTopResult.findCommonFactor();
				if (cf != 1) {
					// adjust division to match hcf (gcd) to be cloest to card value
					if (cf <= result.value) {
						result.value = cf;
						result.varValues = EMPTY_ARRAY;
						return result;
					}
					else {
						// figure out best common factor cloest from..to...gcf, limit to MAX_ITER else use GCF
						
						result.value = cf;  // (NOTE: lazy..) for now, this would be fine
						result.varValues = EMPTY_ARRAY;
						return result; 
					}
				}
				else {
					// perform alternative for result (deriative or divide-see-quotient-only)
					result.operator = Card.OPERATOR_QUOTIENT;
					result.value = cf;  // (NOTE: lazy..) for now, this would be fine
					result.varValues = EMPTY_ARRAY;
					// or consider derirative
					
				}
				return result;
			}
			
		}
		return result;
	}
	
	static var EMPTY_ARRAY:Array<Int> = [];
	
	public function getPolynomial():Polynomial 
	{
		return polynomial;
	}

	public inline function getDeckIndex():Int {
		return curDeck.cards.length - curDeckIndex - 1;
	}
}
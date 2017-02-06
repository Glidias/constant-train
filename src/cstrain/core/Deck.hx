package cstrain.core;

/**
 * Base class and utility for deck building
 * @author Glidias
 */
class Deck 
{
	// General
	
	public var cards:Array<Card> = [];
	public function shuffle():Void {
		arrayShuffleFisherYates(cards);
	}
	
	public static function arrayShuffleFisherYates<T>(array:Array<T>):Array<T>
	{
		var m:Int = array.length;
		var i:Int;
		var temp:T;
	 
		// while there are still elements to shuffle
		while (m != 0)
		{
			i = Std.int(Math.random() * m--);
	 
			// swap it with the current element
			temp = array[m];
			array[m] = array[i];
			array[i] = temp;
		}
	 
		return array;
	}
	
	
	public inline function aimRandomCard():Card {
		return cards[Std.int(Math.random() * cards.length)];
	}
	
	public inline function popCard():Card {
		return cards.pop();
	}
	

	public inline function addCard(card:Card):Void {
		cards.push(card);
	}
	
	public inline function addCardUnderneath(card:Card):Void {
		return cards.unshift(card);
	}
	
	
	// App Specific
	
	public static inline var SET_NUMBERS:Int = (1 << 0);
	public static inline var SET_VARIABLE:Int = (1 << 1);
	public static inline var MASK_SET_ALL:Int = SET_NUMBERS | SET_VARIABLE;
	
	public static inline var NUM_1:Int = (1 << 0);
	public static inline var NUM_2:Int = (1 << 1);
	public static inline var NUM_3:Int = (1 << 2);
	public static inline var NUM_4:Int = (1 << 3);
	public static inline var NUM_5:Int = (1 << 4);
	public static inline var NUM_6:Int = (1 << 5);
	public static inline var NUM_7:Int = (1 << 6);
	public static inline var NUM_8:Int = (1 << 7);
	public static inline var NUM_9:Int = (1 << 8);
	public static inline var NUM_10:Int = (1 << 9);
	public static inline var MASK_NUMBER_ALL:Int = 1023;
	public static inline var MASK_NUMBER_EVEN:Int = NUM_2 | NUM_4 | NUM_6 | NUM_8 | NUM_10;
	public static inline var MASK_NUMBER_ODD:Int = NUM_1 | NUM_3 | NUM_5 | NUM_7 | NUM_9;
	
	
	// assume order matches convention with everything else in framework
	public static inline var OP_ADD:Int = (1 << 0);
	public static inline var OP_SUBTRACT:Int = (1 << 1);
	public static inline var OP_MULTIPLY:Int = (1 << 2);
	public static inline var OP_DIVIDE:Int = (1 << 3);
	public static inline var MASK_OPERATOR_ALL:Int = OP_ADD | OP_SUBTRACT | OP_MULTIPLY | OP_DIVIDE;
	

	
	public function new() 
	{
		
	}
	
	public function addCards(cards:Array<Card>, placeOnTop:Bool = true):Void {
		if (placeOnTop) this.cards = this.cards.concat(cards);
		else this.cards = cards.concat(this.cards);
		
	}

	
	public static function getCards(setMask:Int, operatorMask:Int, constantMask:Int = 0, numTimes:Int = 1):Array<Card> {
		var cards:Array<Card> = [];
		
		if (setMask == 0) setMask = MASK_SET_ALL;
		if (operatorMask == 0) operatorMask = MASK_OPERATOR_ALL;
		
		if (constantMask == 0) constantMask = MASK_NUMBER_ALL;
		
		if ( (setMask & SET_NUMBERS)!=0 ) {
			for (i in 0...numTimes) {
				for (o in 0...4) {
					if ( (operatorMask & (1<<o)) != 0) {
						for ( i in 0...10 ) {
							if ( (constantMask & (1 << i))  != 0 ) {
								cards.push( new Card(o, i + 1) );
							}
						}
					}
				}
			}
		}
		
		if ( (setMask & SET_VARIABLE)!=0 ) {
			for (i in 0...numTimes) {
				for (o in 0...4) {
					if ( (operatorMask & (1<<o)) != 0) {
						cards.push(  Card.getRegularVarCard(o) );
					}
				}
				
			}
		}
		
		return cards;
	}
	

	
	
	
	
}
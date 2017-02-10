package cstrain.core;

/**
 * Reactive card model
 * @author Glidias
 */
class Card
{
	public static inline var OPERATOR_ADD:Int = 0;
	public static inline var OPERATOR_SUBTRACT:Int = 1;
	public static inline var OPERATOR_MULTIPLY:Int = 2;
	public static inline var OPERATOR_DIVIDE:Int = 3;
	
	public static inline var OPERATION_EQUAL:Int = 4;
	
	
	public static inline function isIncreasingMagnitude(op:Int):Bool {
		return canOperate(op) && (op & 1) == 0;
	}
	public static inline function canOperate(op:Int):Bool {
		return  op <= 3;
	}
	
	public static inline function stringifyOp(op:Int):String {
		return op == OPERATOR_ADD ? "+" : op == OPERATOR_SUBTRACT ? "-" : op  == OPERATOR_MULTIPLY ? "*" : op == OPERATOR_DIVIDE ? "/" : op == OPERATION_EQUAL ? "=" : "?";
	}
	
	
	public static function toOperation(card:Card):Operation {
		switch( card.operator) {
			case OPERATOR_ADD: return Operation.ADD(card.value, card.isVar);
			case OPERATOR_SUBTRACT: return Operation.SUBTRACT(card.value, card.isVar);
			case OPERATOR_MULTIPLY: return Operation.MULTIPLY(card.value, card.isVar);
			case OPERATOR_DIVIDE: return Operation.DIVIDE(card.value, card.isVar);
			
			case OPERATION_EQUAL: return Operation.EQUAL(card.value, card.isVar);
			default:
				throw "Card:: toOperation invalid operator:"+card.operator;
			return null;
		}
	}
	
	// current card value
	public var operator:Int;
	public var value:Int;
	public var isVar:Bool;	
	// to hold an alternate card value representation, (by convention, for swiping right..)
	public var virtualRight:Card;
	public var varValues:Array<Int>=null; // mainly for holding polynormial variable coeffecient values (if any) from degree 1 onwards

	public function new(op:Int, value:Int, isVar:Bool=false, virtualRight:Card=null ) 
	{
		this.operator = op;
		this.value = value;
		this.isVar = isVar;
		this.virtualRight = virtualRight;
	}
	
	public static inline function getRegularVarCard(operator:Int):Card {
		return new Card(operator, 1, true);
	}
	
		
	public static inline function getRegularGuessConstantCard(value:Int, value2:Int):Card {
		return new Card(OPERATION_EQUAL, value, false, new Card(OPERATION_EQUAL, value2, false) );
	}
	
	public static inline function getRegularStartingVarCard():Card {
		return new Card(OPERATOR_ADD, 1, true );
	}
	
	
	
	
	
}
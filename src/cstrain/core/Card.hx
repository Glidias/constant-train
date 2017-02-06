package cstrain.core;

/**
 * ...
 * @author Glidias
 */
class Card
{
	public static inline var OPERATOR_ADD:Int = 0;
	public static inline var OPERATOR_SUBTRACT:Int = 1;
	public static inline var OPERATOR_MULTIPLY:Int = 2;
	public static inline var OPERATOR_DIVIDE:Int = 3;
	public static inline function isIncreasingMagnitude(op:Int):Bool {
		return (op & 1) != 0;
	}
	
	public static function toOperation(card:Card):Operation {
		switch( card.operator) {
			case OPERATOR_ADD: return Operation.ADD(card.value, card.isVar);
			case OPERATOR_SUBTRACT: return Operation.SUBTRACT(card.value, card.isVar);
			case OPERATOR_MULTIPLY: return Operation.MULTIPLY(card.value, card.isVar);
			case OPERATOR_DIVIDE: return Operation.DIVIDE(card.value, card.isVar);
			default:
				throw "Card:: toOperation invalid operator:"+card.operator;
			return null;
		}
	}
	
	public var operator:Int;
	public var value:Int;
	public var isVar:Bool;

	public function new(op:Int, value:Int, isVar:Bool=false ) 
	{
		this.operator = op;
		this.value = value;
		this.isVar = isVar;
	}
	
	public static inline function getRegularVarCard(operator:Int):Card {
		return new Card(operator, 1, true);
	}
	
	
	
	
	
}
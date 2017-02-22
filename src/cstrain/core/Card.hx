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
	public static inline var OPERATOR_QUOTIENT:Int = 4;
	static inline var NUM_OPERATORS:Int = 4;
	
	
	public static inline var OPERATION_EQUAL:Int = 5;
	
	
	public static inline function isIncreasingMagnitude(op:Int):Bool {
		return canOperate(op) && (op & 1) == 0;
	}
	public static inline function canOperate(op:Int):Bool {
		return  op <= NUM_OPERATORS;
	}
	
	public static inline function stringifyOp(op:Int):String {
		return op == OPERATOR_ADD ? "+" : op == OPERATOR_SUBTRACT ? "-" : op  == OPERATOR_MULTIPLY ? "*" : op == OPERATOR_QUOTIENT ? "\\" : op == OPERATOR_DIVIDE ? "/" : op == OPERATION_EQUAL ? "=" : "?";
	}
	
	static function intArrayToFloatArr(arr:Array<Int>):Array<Float> {
		var flArr:Array<Float> = [];
		for (i in 0...arr.length) {
			flArr[i] = arr[i];
		}
		
		return flArr;
	}
	
	
	public static function toOperation(card:Card):Operation {
		switch( card.operator) {
			case OPERATOR_ADD: return Operation.ADD(card.value, card.isVar);
			case OPERATOR_SUBTRACT: return Operation.SUBTRACT(card.value, card.isVar);
			case OPERATOR_MULTIPLY: return Operation.MULTIPLY(card.value, card.isVar);
			case OPERATOR_DIVIDE | OPERATOR_QUOTIENT: return card.isPolynomialAny() ? Operation.DIVIDE_BY_POLYNOMIAL( intArrayToFloatArr([card.value].concat(card.varValues) ) ) : Operation.DIVIDE(card.value, card.isVar); 
	
			
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
	public var varValues:Array<Int> = null; // mainly for holding polynormial variable coeffecient values (if any) from degree 1 onwards. 
	// If empty array, means an attempt was made to set it to a polynomial, but is ended up being a non-variable.
	
	public inline function isPolynomialOfVars():Bool {
		return varValues != null && varValues.length > 1;
	}

	public inline function isPolynomialAny():Bool {
		return varValues != null && varValues.length > 0;
	}
	
	public function setPolynomial(polynomial:Polynomial):Void {
		var values:Array<Float> =  polynomial.coefs.slice(1);
		varValues  = [];
		for (i in 0...values.length) {
			varValues[i] =Std.int( values[i]);
		}
		value = Std.int(polynomial.coefs[0]);
		isVar = varValues.length != 0;
	}
	
	public function getPolynomial():Polynomial {
		var values:Array<Float> = [];
		if (varValues != null) {
			for (i in 0...varValues.length) {
				values[i] = varValues[i];
			}
		}
		return Polynomial.fromCoefs( [value+.0].concat( values ) );
	}
	
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
package cstrain.core;

/**
 * A basic single variable polynomial expression
 * @author Glidias
 */
class Polynomial
{
	public var coefs:Array<Float> = [0];  //  polynomial expression:  Float^i  , where `i` is array index
	
	public function new() 
	{
	}
	
	public var  isUnknown(get, never):Bool;
	public inline function get_isUnknown():Bool  {
		return coefs.length > 1;
	}
	
	public var  constantInteger(get, never):Int;
	public inline function get_constantInteger():Int  {
		return Std.int( coefs[0] );
	}
	
	public var  constantValue(get, never):Float;
	public inline function get_constantValue():Float  {
		return coefs[0];
	}

	
	function cleanupPolynomial():Void {
		var i:Int = coefs.length;
		while (--i > 0) {
			if (coefs[i] != 0) break;
			else coefs.pop();
		}
	}
	
	public function performOperation(op:Operation):Void {
		
		switch( op ) {
			case Operation.ADD(value, isVar): 
				if (isVar && coefs.length < 2 ) {
					coefs.push(0);
				}
				coefs[isVar ? 1 : 0] += value;
				
			case Operation.SUBTRACT(value, isVar):
				if (isVar && coefs.length < 2 ) {
					coefs.push(0);
				}
				coefs[isVar ? 1 : 0] -= value;

			case Operation.MULTIPLY(value, isVar):
				if (isVar) 	coefs.unshift(0);
				for ( i in 0...coefs.length) {
					coefs[1] *= value;
				}
			case Operation.DIVIDE(value, isVar):
				if (value == 0) throw "Divide by zero error detected!";
				if (isVar) 	coefs.unshift(0);
				for ( i in 0...coefs.length) {
					coefs[1] /= value;
				}
			default:
		}
		
		cleanupPolynomial();
	}
		
	
}
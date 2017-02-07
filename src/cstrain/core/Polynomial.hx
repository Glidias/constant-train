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
	
	public static function floatToStringPrecision(n:Float, prec:Int){
	   n *= Math.pow(10, prec);
		return Std.string( Math.round(n) / Math.pow(10, prec) );
	}


	public static inline function getSign(co:Float):String {
		return co!= 0 ? co < 0 ? "" : "+" : "";
	}
	public static inline function getRepresentation(co:Float, level:Int, varLabel:String):String {
		return co!= 0 ? (  co != 1 || level < 1 ? floatToStringPrecision(co, 2) + "" : "" ) + (level >= 1 ? varLabel : "") + (level >= 2 ? "<sup>"+level+"</sup>" : "") : "";
	}
	public static inline function precision(co:Float):String {
		return floatToStringPrecision(co, 2);
	}
	
	public static  function PrintOut(poly:Polynomial, varLabel:String):String {
		
		var arr:Array<String> = [getSign(poly.coefs[0]) + getRepresentation(poly.coefs[0], 0, varLabel) ];
		for (i in 1...poly.coefs.length) {
			arr.push ( getSign(poly.coefs[i]) + getRepresentation(poly.coefs[i], i, varLabel)  );
		}
		arr.reverse();
		
		if (arr[0].charAt(0) == "+") {
			arr[0] = arr[0].substr(1);
		}
		return arr.join(" ");
		
		
	
	}
	
	public static function Copy(poly:Polynomial):Polynomial {
		var me:Polynomial = new Polynomial();
	
		me.coefs = poly.coefs.concat([]);
		return me;
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
	
	public function calculateValueInt(varValue:Int):Int {
		var sum:Float = 0;
		for (i in 0...coefs.length) {
			sum += coefs[i] * Math.pow( varValue, (1 << i));
		}
		return Std.int(sum);
	}
	public function calculateValueFloat(varValue:Float):Float {
		var sum:Float = 0;
		for (i in 0...coefs.length) {
			sum += coefs[i] * Math.pow( varValue, (1 << i));
		}
		return sum;
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
				trace("+:" + value+ ", "+isVar);
				coefs[isVar ? 1 : 0] += value;
				
			case Operation.SUBTRACT(value, isVar):
				if (isVar && coefs.length < 2 ) {
					coefs.push(0);
				}
				trace("-:" + value+ ", "+isVar);
				coefs[isVar ? 1 : 0] -= value;

			case Operation.MULTIPLY(value, isVar):
				if (isVar) 	coefs.unshift(0);
					trace("*:" + value + ", "+isVar);
				for ( i in 0...coefs.length) {
					coefs[i] *= value;
				}
			case Operation.DIVIDE(value, isVar):
				if (value == 0) throw "Divide by zero error detected!";
				if (isVar) 	coefs.pop();
				trace("/:" + value+ ", "+isVar);
				for ( i in 0...coefs.length) {
					coefs[i] /= value;
				}
			default:
				trace("UInaccounted for operation:" + op);
		}
		
		cleanupPolynomial();
	}
		
	
}
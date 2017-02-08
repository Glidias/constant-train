package cstrain.core;

/**
 * A basic single variable polynomial expression
 * 
 * Partly ported from: https://github.com/2m/polyfact/blob/master/src/Polynomial.java
 * 
 * @author Glidias
 */
class Polynomial
{
	public var coefs:Array<Float> = [0];  //  polynomial expression:  Float^i  , where `i` is array index

	public function new() 
	{
		
	}
	
	public static function fromCoefs(arr:Array<Float>):Polynomial {
		var d:Polynomial = new Polynomial();
		d.coefs = arr;
		return d;
	}
	
	/**
	 * @return	A new polynomial which is a differentiation from the current one
	 */
	public function differentiate():Polynomial {
		var deriv:Polynomial = new Polynomial();
		if (deg() == 0) return deriv;
		for (i in 0...coefs.length-1) {
			deriv.coefs[i] = coefs[i+1] * (i+1);
		}
		return deriv;
	}
	

	
	/**
     * Returns degree of the polynomial which is the highest degree
     * where coefficient is not zero.
     * Degree of empty polynomial is -1.
     */
    public inline function deg():Int {
        return coefs.length - 1;
    }
	
	public inline function getCoef(i:Int):Float {
		return this.deg() < i ? null : coefs[i];
	}
	
	
    /**
     * Return true if polynomial is zero.
     * Which is degree of polynomial is zero and
     * the only coefficient is also zero.
     */
    public  function isZero():Bool {
        return (this.deg() == 0 && this.getCoef(0) == 0);  // izZero, should it account for floating point roundown?
    }
	
	 /**
     * Adds coeffient to another coefficient.
     *
     * @param i         index where coefficient must be added.
     * @param value     the coefficient which will be added.
     */
    public function addCoef( i:Int, value:Float):Void {
        var oldCoef:Float = getCoef(i);

        if (oldCoef == null) {
            // if polynomial is shorter than specified index,
            // create zero coefficient
            oldCoef = 0;// (T) value.getZero();
        }

        setCoef(i, oldCoef + value);  //(T)oldCoef.add(value)
    }

	 public function setCoef(i:Int, value:Float) {
        while (this.deg() < i) {
            this.coefs.push(0);  //.add(0) //(T)value.getZero()
        }

        this.coefs[i] = value; // this.coefs.set(i, value);
    }
	
	public function copyFrom(p:Polynomial):Void {
		var coefs:Array<Float> = [];
		for (i in 0...p.coefs.length) {
			coefs[i] = p.coefs[i];
		}
		this.coefs = coefs;
	}

	
	  /**
     * Adds one polynomial to another, and returns
     * new polynomial as a result.
     * Does not modify any polynomials.
     */
    public function add(b:Polynomial):Polynomial {
		var result:Polynomial, shorterOne:Polynomial;

        // figure out which is longer, and set that as a result
        if (this.deg() > b.deg()) {
            result = this.clone();
            shorterOne = b;
        }
        else {
            result = b.clone();
            shorterOne = this;
        }

        // add all coefficients of the shorter one to the longer one
        for (i in 0...shorterOne.deg() + 1) {
            result.addCoef(i, shorterOne.getCoef(i));
        }

        trim(result);
        return result;
    }
	
	 /**
     * Subtract one polynomial from another.
     */
    public function sub(b:Polynomial):Polynomial {
		var result:Polynomial = this.add(b.mulI(-1));
        trim(result);
        return result;
    }
	
	 /**
     * Divides one polynomial by another
     * and returns integer and remainder parts.
     *
     * @return ArrayList where polynomial at index 0 is integer part
     *                     and polynomial at index 1 is remainder.
     */
    public function divisionWithRemainder(b:Polynomial):Array<Polynomial> {

        // check for division by zero
        if (b.isZero()) {
           throw "divisionWithRemainder:: / by zero";// throw(new ArithmeticException("/ by zero"));
        }

        // result will be ArrayList with to polynomials
        var result:Array<Polynomial> = [];

        // remainders will be stored here
        var a:Polynomial = this;  //Polynomial<T>

        // integer part will be stored here
        var integer:Polynomial = new Polynomial();  //

        var deg:Int = a.deg() - b.deg();

        while (deg >= 0 && !a.isZero()) {
            var coefA = a.getCoef(a.deg());
            var coefB = b.getCoef(b.deg());
            var coefI = coefA * 1/coefB; //coefA.mul(coefB.inv());  // inv is negative??

            integer.setCoef(deg, coefI);

            // temporary Polynomial for multiplying b
			var temp = new Polynomial();
            temp.setCoef(deg, coefI);

            a = a.sub(b.mul(temp));

            deg = a.deg() - b.deg();
        }

        result.push(integer);
        result.push(a);
        return result;
    }
	
	 /**
     * Returns the integer part of division.
     */
    public function  div(b:Polynomial):Polynomial {
        return this.divisionWithRemainder(b)[0];
    }

    /**
     * Returns the remainder part of division.
     */
    public function rem( b:Polynomial):Polynomial {
        return this.divisionWithRemainder(b)[1];
    }
	
	public static inline function evaluateDivisionRemAsFloat(quotRem:Array<Polynomial>, varValue:Float):Float {
		//basePoly.calculateValueFloat(
		return evaluateDivisionsAsFloat(quotRem[0], quotRem[1], varValue);
	}
	
	public static inline function evaluateDivisionsAsFloat(basePoly:Polynomial, remPoly:Polynomial, varValue:Float):Float {
		//basePoly.calculateValueFloat(
		return basePoly.evalValueFloat(varValue) + remPoly.evalValueFloat(varValue) / varValue;
	}
	
	

	
	public static function createDeg1x():Polynomial {
		var poly:Polynomial = new Polynomial();
		poly.coefs.push(1);
		return poly;
	}


	/**
     * Multiplies one polynomial by another,
     * and returns new polynomial as a result.
     * Does not modify any polynomials.
     */
	public function mul(b:Polynomial):Polynomial {
        var result:Polynomial = new Polynomial();

        var degA:Int = this.deg();
        var degB:Int = b.deg();

        for (i in 0...degA+1) {
            for (j in 0...degB+1) {
                var termA = this.getCoef(i);
                var termB = b.getCoef(j);
                result.addCoef(i + j, termA*termB);  //termA.mul(termB)
            }
        }

        trim(result);
        return result;
    }
	
	 /**
     * Multiply polynomial by integer,
     * which is multiply all coefficients by integer.
     */
	public function mulI(a:Int):Polynomial {
		var result:Polynomial = clone();
		for ( i in 0...result.coefs.length ) {
			result.setCoef(i, result.getCoef(i) * a);// .mul(a));
		}	
		trim(result);
		return result;
	}
	
	public static function trim(a:Polynomial) {
        var i:Int = a.deg();
        while (i > 0 && a.getCoef(i) == 0 ) { //.isZero(
            a.coefs.splice(i, 1);
            i--;
        }
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
	public function clone():Polynomial {
		return Copy(this);
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
	
	public function evalValueInt(varValue:Int):Int {
		var sum:Float = 0;
		for (i in 0...coefs.length) {
			sum += coefs[i] * Math.pow( varValue, i);
		}
		return Std.int(sum);
	}
	public function evalValueFloat(varValue:Float):Float {
		var sum:Float = 0;
		for (i in 0...coefs.length) {
			sum += coefs[i] * Math.pow( varValue, i); //(1 << i)
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
	
	// game specific simplified operations (mutative)
	
	public function performOperation(op:Operation):Void {
		
		
		switch( op ) {
			case Operation.ADD(value, isVar): 
				if (isVar && coefs.length < 2 ) {
					coefs.push(0);
				}
				//trace("+:" + value+ ", "+isVar);
				coefs[isVar ? 1 : 0] += value;
				
			case Operation.SUBTRACT(value, isVar):
				if (isVar && coefs.length < 2 ) {
					coefs.push(0);
				}
				//trace("-:" + value+ ", "+isVar);
				coefs[isVar ? 1 : 0] -= value;

			case Operation.MULTIPLY(value, isVar):
				if (isVar) 	coefs.unshift(0);
				//trace("*:" + value + ", "+isVar);
				for ( i in 0...coefs.length) {
					coefs[i] *= value;
				}
			case Operation.DIVIDE(value, isVar):
				if (value == 0) throw "Divide by zero error detected!";
				if (isVar) 	{
					// TODO
				}
				else {	
					for ( i in 0...coefs.length) {
						coefs[i] /= value;
					}
				}
			default:
				trace("UInaccounted for operation:" + op);
		}
		
		cleanupPolynomial();
	}
		
	
}
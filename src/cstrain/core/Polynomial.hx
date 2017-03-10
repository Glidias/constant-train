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
	
	public function isRootFor(x:Float):Bool {
		return coefs.length > 1 && evalValueFloat(x) == 0;
	}
	
	public function findRoot():Float {
		//trace("Finding root:" + this.coefs);
		if (isRootFor(0)) {
			//trace("Zero reached");
			return 0;
		}
		if (  !isWholeNum(coefs[0]) || !isWholeNum(coefs[coefs.length - 1]) ) {
			trace("Invalid not whole number coeffs!");
			return null;
		}
		
		var last:Int = Std.int( Math.abs( coefs[0] ) );
		var first:Int  = Std.int( Math.abs( coefs[coefs.length -1] ) );
		for ( l in 1...last+1) {
			//if ( !divisible(last, l)) continue;
			
			if ( (last % l) != 0) continue;
			
			for ( f in 1...first+1) {
				//if ( !divisible(first, f)) continue;
				
				if ( ( first % f) != 0) continue;
				var r = l / f;
				//trace("trying for " + l + "/" + f);
				if ( isRootFor(r) ) {
					return r;
				}
				if ( isRootFor( -r) ) {
					return -r;
				}
			}
		}
		
		return null;
	}
	
	public function reduceByRoot(r:Float):Bool {
		var new_p:Array<Float> = [];
		var carry = .0;
		var down:Float = 9999;
		var gotDown:Bool = false;
		var i:Int = this.coefs.length;
	
		while(--i > -1)  {
			var coef = this.coefs[i];		    // coefficient
			//var deg  = this.coefs.length - i - 1;   // degree
			down = coef + carry; gotDown = true;
			carry = down * r;
			new_p.unshift(down);
		}
		if (gotDown && down ==0) {
			new_p.shift();
			this.coefs = new_p;
			return true;
			} else {
			return false;
			}
	
	}
	
	public function isWhole():Bool {
		for (i in 0...coefs.length) {
			if (!isWholeNum(coefs[i])) return false;
		}
		return true;
	}

	
	public function findCommonFactor() {
	
		if (isWhole() && coefs.length > 1) {
			return gcd_mult(coefs);
		} else {
			return 1;
		}

	}
	
	/*
	 toCHECK
/2=0.5 coef  // does this hapen anymore with allowFloatCoef flag?

	 */
	
	public function factorisation(allowFloatCoef:Bool=false):Array<Polynomial> {
		
		 var factors:Array<Polynomial> = [];

		var root = findRoot();

		if (root != null && (allowFloatCoef || isWholeNum(root) ) ) { 
			
			factors.push( Polynomial.fromCoefs([ -root, 1]) );
			var p:Polynomial = clone();
				
			p.reduceByRoot(root);
		
			addToArray(factors, p.factorisation() );
		}
		else {
			//trace("getting common factor");
			
			var p:Polynomial = clone();
			var cf = p.findCommonFactor();
			if (cf != 1) {
				 for (i in 0...coefs.length) {
					p.coefs[i] /= cf;
				}
				factors.push( Polynomial.fromCoefs([cf]));
			}
			factors.push(p);
		}
		
		return factors;
	}
	
	public function toString():String {
		return "[Polynomial: "+PrintOut(this, "x", false) + "]";
	}
	

	
	static function gcd(x:Float, y:Float):Int {
		var z:Int = 1;
		 x = Math.abs(Std.int(x));
		 y = Math.abs(Std.int(y));
		while (z!=0) {
			z = Std.int(x % y);
			x = y;
			y = z;
		}
		return Std.int(x);
	}

	static function gcd_mult(ref:Array<Float>):Int  {
		var d:Float = ref[ref.length - 1];
		var i:Int = ref.length - 1;
		while (--i > -1) {
			if (Std.int(ref[i]) != 0) {
				d = gcd(d, ref[i]);
			}
		}
		return Std.int(d);
	}
	
	public function addToArray<T>(a:Array<T>, ref:Array<T>) { 
		for (i in 0...ref.length) {
			a.push(ref[i]);
		}
	}
	
	static inline function isWholeNum(num:Float):Bool {
		return (num % 1) == 0;
	}
	
	static inline function divisible(a:Float, d:Float):Bool {
		return a % d == 0;
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
	public static inline function getRepresentation(co:Float, level:Int, varLabel:String, isHTML:Bool):String {
		return co!= 0 ? (  co != 1 || level < 1 ? floatToStringPrecision(co, 2) + "" : "" ) + (level >= 1 ? varLabel : "") + (level >= 2 ? isHTML ? "<sup>"+level+"</sup>" : "^"+level : "") : "";
	}
	public static inline function precision(co:Float):String {
		return floatToStringPrecision(co, 2);
	}
	

	public static  function PrintOut(poly:Polynomial, varLabel:String, isHTML:Bool):String {
		
		var arr:Array<String> = [getSign(poly.coefs[0]) + getRepresentation(poly.coefs[0], 0, varLabel, isHTML) ];
		for (i in 1...poly.coefs.length) {
			arr.push ( getSign(poly.coefs[i]) + getRepresentation(poly.coefs[i], i, varLabel, isHTML)  );
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
	public inline function clone():Polynomial {
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
	
	public function performOperationImmutable(op:Operation):Polynomial {
		var result:Polynomial = null;
		switch( op ) {
			case Operation.ADD(value, isVar): 
				result = add(Polynomial.fromCoefs( isVar ? [0, value] : [value] ) );
			case Operation.SUBTRACT(value, isVar):
				result = sub( Polynomial.fromCoefs( isVar ? [0, value] : [value]  ));
			case Operation.MULTIPLY(value, isVar):
				result = mul( Polynomial.fromCoefs( isVar ? [0, value] : [value]  ) );
			case Operation.DIVIDE(value, isVar):
				if (value == 0) throw "Divide by zero error detected!";
				if (isVar) {
					result = div( Polynomial.fromCoefs( [0, value] ) );
				}
				else {
					result = mul( Polynomial.fromCoefs( [1/value] ) );
				}	
			case Operation.DIVIDE_BY_POLYNOMIAL(values):
				trace("This shouldn't happen DIVIDE_BY_POLYNIMAL for immutable");
				result =  div( Polynomial.fromCoefs(values) );
			case Operation.DERIVATIVE:
				result =  differentiate();
			default:
				trace("UInaccounted for operation:" + op);
		}
		
		return result;
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
					// would a quotient divide suffice?  woudlnt remainder or negative exponents need to be saved to allow reverting back?
					
					// consider alternate factorisation divisor setup for: value.
					copyFrom( div( Polynomial.createDeg1x() ) );
				}
				else {	
					for ( i in 0...coefs.length) {
						coefs[i] /= value;
					}
				}
			case Operation.DIVIDE_BY_POLYNOMIAL(values):
				//trace("Dividing by polynomial:" + values);
				var resultTest = div( Polynomial.fromCoefs(values) );
				copyFrom( resultTest );
				//trace( resultTest.coefs + " vs "+coefs);
			case Operation.DERIVATIVE:
				var resultTest = differentiate();
				copyFrom(resultTest);
				
			default:
				trace("UInaccounted for operation:" + op);
		}
		
		cleanupPolynomial();
	}
		
	
}
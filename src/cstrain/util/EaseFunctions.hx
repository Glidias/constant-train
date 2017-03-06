package cstrain.util;

/**
 * Pure easing functions with their deriatives (for deriving velocity and such..)
 * @author Glidias
 */
class EaseFunctions {

	// Common Polynomial Acceleration functions (see EaseFunctions class for more info)
	
	// Linear (deg1)
	public static inline function linearDistCovered(t:Float):Float {
		return  t;
	}
	
	public static inline function linearDistCoveredGetX(offset:Float):Float {
		return offset;
	}
	
	
	public static inline function linearDeriative(x:Float):Float {
		return 1;
	}
	
	public static inline function linearDeriativeGetX(v:Float):Float {
		return  0;
	}
	
	
	// Quadratic (deg2)
	
	public static inline function quadraticDistCovered(t:Float):Float {
		return  t * t;
	}
	public static inline function quadraticDistCovered_Out(t:Float):Float {
		return  t * (2 - t);
	}
	
	public static inline function quadraticDistCoveredGetX(offset:Float):Float {
		return Math.sqrt(offset);
	}
	
	
	public static inline function quadraticDeriative(x:Float):Float {
		return 2 * x;
	}
	
	public static inline function quadraticDeriativeGetX(v:Float):Float {
		return  v  / 2;
	}
	
	
	
	
	// Cubic (deg3)
	
	public static inline function cubicDistCovered(t:Float):Float {
		return  t * t * t;
	}
	public static inline function cubicDistCovered_Out(t:Float):Float {
		return  --t * t * t + 1;
	}
	
	public static inline function cubicDistCoveredGetX(offset:Float):Float {
		return Math.pow(offset, 1 / 3);
	}
	
	
	public static inline function cubicDeriative(x:Float):Float {
		return 3 * x * x;
	}
	
	public static inline function cubicDeriativeGetX(v:Float):Float {
		return  Math.sqrt( v  / 3);
	}
	
	// Quartic (deg4)
	public static inline function quarticDistCovered(t:Float):Float {
		return  t * t * t * t;
	}
	public static inline function quarticDistCovered_Out(t:Float):Float {
		return  1 - (--t) * t * t * t;
	}
	
	public static inline function quarticDistCoveredGetX(offset:Float):Float {
		return Math.pow(offset, 1 / 4);
	}
	
	
	public static inline function quarticDeriative(x:Float):Float {
		return 4 * x * x * x;
	}
	
	public static inline function quarticDeriativeGetX(v:Float):Float {
		return  Math.pow( v  / 4, 1/3);
	}
	
	
	// Quintic (deg5)
	public static inline function quinticDistCovered(t:Float):Float {
		return  t * t * t * t * t;
	}
	public static inline function quinticDistCovered_Out(t:Float):Float {
		return  return 1 + (--t) * t * t * t * t;
	}
	
	public static inline function quinticDistCoveredGetX(offset:Float):Float {
		return Math.pow(offset, 1/5);
	}
	
	
	public static inline function quinticDeriative(x:Float):Float {
		return 5 * x * x * x * x;
	}
	
	public static inline function quinticDeriativeGetX(v:Float):Float {
		return  Math.pow( v  / 5, 1/4);
	}
	
	function new() {
		
	}
	
	public static inline var LINEAR:Int = 0;
	public static inline var QUADRATIC:Int = 1;
	public static inline var CUBIC:Int = 2;
	public static inline var QUARTIC:Int = 3;
	public static inline var QUINTIC:Int = 4;
	
	
	public var distCovered:Float->Float;	// displacement function over time (easeIn)
	public var distCovered_Out:Float->Float; // displacement function over time (easeOut)
	public var distCoveredGetX:Float->Float;	// solve for X time, with displacement function, given displacement value
	public var deriative:Float->Float;	//  the velocity function over time. (which is 1st deriative of the displacement function)
	public var deriativeGetX:Float->Float;	// solve for X time, with velocity function, given velocity value
	
	public static function create(powerIndex:Int):EaseFunctions {
		var me:EaseFunctions = new EaseFunctions();
		switch( powerIndex) {
			case LINEAR:
				me.distCovered = linearDistCovered;
				me.distCovered_Out = linearDistCovered;
				me.distCoveredGetX = linearDistCoveredGetX;
				me.deriative = linearDeriative;
				me.deriativeGetX = linearDeriativeGetX;
			case QUADRATIC:
				me.distCovered = quadraticDistCovered;
				me.distCovered_Out = quadraticDistCovered_Out;
				me.distCoveredGetX = quadraticDistCoveredGetX;
				me.deriative = quadraticDeriative;
				me.deriativeGetX = quadraticDeriativeGetX;
			case CUBIC:
				me.distCovered = cubicDistCovered;
				me.distCovered_Out = cubicDistCovered_Out;
				me.distCoveredGetX = cubicDistCoveredGetX;
				me.deriative = cubicDeriative;
				me.deriativeGetX = cubicDeriativeGetX;
			case QUARTIC:
				me.distCovered = quarticDistCovered;
				me.distCovered_Out = quarticDistCovered_Out;
				me.distCoveredGetX = quarticDistCoveredGetX;
				me.deriative = quarticDeriative;
				me.deriativeGetX = quarticDeriativeGetX;
			case QUINTIC:
				me.distCovered = quinticDistCovered;
				me.distCovered_Out = quinticDistCovered_Out;
				me.distCoveredGetX = quinticDistCoveredGetX;
				me.deriative = quinticDeriative;
				me.deriativeGetX = quinticDeriativeGetX;
			default:
				if (powerIndex > 0) {
					trace("Warning:: no easing functions case found");
				}
		}
		
		return me;
	}
}
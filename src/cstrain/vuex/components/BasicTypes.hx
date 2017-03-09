package cstrain.vuex.components;

import gajus.swing.Swing;
import cstrain.core.Card;

/**
 * Common typedefs
 * @author Glidias
 */
typedef SwingStackData = {
	var refCards:Array<RefCard>;

	var topCardIndex:Int;
	var beltAmount(default, never):Int;

	@:optional var _stack:SwingStack;

}

typedef RefCard = {
	@:optional  var card:Card;
}

class TouchVUtil {
	public static var IS_TOUCH_BASED:Bool = false;
	
	public static inline var TAG:String = "touch";

}

class BuiltVUtil {
	public static inline function isProductionStr():String {
		#if production
			return "true";
		#else
			return "false";
		#end
	}
	
	public static inline function isProductionStrNot():String{ 
		#if production
			return "false";
		#else
			return "true";
		#end
	}
	
	public static inline function isProduction():Bool {
		#if production
			return true;
		#else
			return false;
		#end
	}
}
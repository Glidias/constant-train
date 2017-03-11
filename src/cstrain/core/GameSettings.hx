package cstrain.core;
import cstrain.util.FastRNG;
import hashids.Hashids;

/**
 * ...
 * @author Glidias
 */
class GameSettings
{

	public var minTurnTime:Float = 1;
	
	public var penaltyDelayMs:Float = 0;
	//public var penaltyDelayMs:Float;
	
	//public static inline function getDelayFor(
	
	public static inline var SHARED_FPS:Int = 80;
	
	static inline function delayInSeconds(ms:Float):Float {
		return ms / 1000;
	}
	
	public var uniqueID:String = "";
	
	
	public static inline function getRandomSeed():Int {
	
		return FastRNG.newSeed(); // Std.int(Math.random() * INT_MAX);
	}
	// 0x7FFFFFFF; // 

	
	static inline var HASH_SALT:String = "this is my salt";
	//static inline var HASH_CHARS:String = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789";
	static inline var HASH_CHARS:String = "abcdefghijkmnopqrstuvwxyz1234567890";
	static var HASHIDS = new Hashids(HASH_SALT, 0, HASH_CHARS);
	
	public static function getUniqueID(seed:Int, ?params:Array<Int>):String 
	{
		var seedU:Int = seed < 0 ? -seed : seed;
		
		var arr:Array<Int> = params != null ? [] : null;
		if (arr != null) {
			for (i in 0...params.length) {
				var neg:Bool =  params[i] < 0;
				arr.push( neg ? 1 : 0);
				arr.push( neg  ?  -params[i] : params[i] );
			}
		}
	
		
		var baseArr:Array<Int> = seed < 0 ? [1, seedU] : [0, seedU];
		var result =  HASHIDS.encode(null, arr != null  ? baseArr.concat(arr) : baseArr);
	
		#if !production
			trace("SEED:" + seed);
			if (getSeedFromUniqueId(result) != seed) {
				trace("Exception error occured mismatch seed!");
				trace(getSeedFromUniqueId(result) + " VS: "+seed);
			}
			if ( !arrayMatches(getOptionsFromUniqueId(result), params)) {
				trace("Exception error occured mismatch Params!");
				trace(getOptionsFromUniqueId(result) + " VS: "+params);
			}
		#end
		
		return result;
	}
	
	static function arrayMatches(a:Array<Int>, b:Array<Int>):Bool {
		if ( (a == null||a.length==0) && (b == null||b.length==0) ) return true;
		
		if (a.length != b.length) return false;
		for (i in 0...a.length) {
			if (a[i] != b[i]) return false;
		}
		return true;
	}
	
	public static function getSeedFromUniqueId(id:String):Int {
		var values:Array<Int> = HASHIDS.decode(id);
		return values[0] != 0 ?  values[1]*-1 : values[1];

	}
	
	static inline function getValueAtIndex(arr:Array<Int>, index:Int):Int {
		 return arr[index] != 0 ? arr[index+1] *-1 : arr[index+1];
	 }
	public static function getOptionsFromUniqueId(id:String):Array<Int> {
		var values:Array<Int> = HASHIDS.decode(id);
		if ( values.length >= 3 ) {
			var i:Int = 2;
			var arr:Array<Int> = [];
			while ( i < values.length) {
				arr.push( getValueAtIndex(values, i) );
				i += 2;
			}
			return arr;
		}
		else {
			return null;
		}
	}
	
	public function new() 
	{
		
	}
	
}

typedef GameOptions = {
	@:optional var seed:Int;
	@:optional var options:Array<Int>;
}
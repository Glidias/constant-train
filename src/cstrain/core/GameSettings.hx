package cstrain.core;

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
	
	public function new() 
	{
		
	}
	
}
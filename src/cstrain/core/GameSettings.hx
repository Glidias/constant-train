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
	
	static inline function delayInSeconds(ms:Float):Float {
		return ms / 1000;
	}
	
	public function new() 
	{
		
	}
	
}
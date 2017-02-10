package cstrain.core;

/**
 * Player-specific game stats holder
 * @author Glidias
 */
class PlayerStats
{
	public var missedStops:Int = 0;
	public var reachedStops:Int = 0;
	public var lostInTransits:Int = 0;
	
	
	
	public var lastMovedTime:Float=0;
	public var startTime:Float = 0;
	public var finishedTime:Float = 0;
	
	public function new() 
	{
	
	}
	
	public function clone():PlayerStats {
		var c:PlayerStats = new PlayerStats();
		copyTo(c);
		return c;
	}
	public function copyTo(c:PlayerStats):Void {
		c.missedStops = missedStops;
		c.reachedStops = reachedStops;
		c.lostInTransits = lostInTransits;
		c.lastMovedTime = lastMovedTime;
		c.startTime = startTime;
		c.finishedTime = 0;
	}
	
}
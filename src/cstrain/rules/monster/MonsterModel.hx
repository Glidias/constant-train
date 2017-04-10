package cstrain.rules.monster;

/**
 * A simple monster model
 * @author Glidias
 */
class MonsterModel
{

	public var specs:MonsterSpecs;
	
	public static inline var STATE_NOT_MOVING:Int = 0;
	public static inline var STATE_LEFT:Int = 1;
	public static inline var STATE_RIGHT:Int = 2;

	
	
	// situation
	public var headOffset:Float;
	public var dance:Float;
	public var timer:Float;
	public var state:Int;
	
	public var angry:Bool;
	public var asleepTime:Float;
	public var currentPosition:Float;
	public var weaponCooldownTime:Float;
	
	

	public function new(specs:MonsterSpecs=null) 
	{
		if (specs == null) specs = new MonsterSpecs();
		
		this.specs = specs;
		state  = STATE_NOT_MOVING;
		angry = false;
		headOffset = 0;
		weaponCooldownTime = specs.baseFireRate;
		asleepTime = specs.startSleepTime;
		currentPosition = 0;
		
	}
	
}
package cstrain.rules.monster;

/**
 * ...
 * @author Glidias
 */
class MonsterSpecs implements IMonsterSpecs
{
	
	
	public var startSleepTime(get, null):Float;
	public var baseAttackRange(get, null):Float;
	public var baseDamage(get, null):Float;
	public var baseAttackRate(get, null):Float;
	public var baseSpeed(get, null):Float;
	
	public function new() 
	{
		
	}
	
	function get_startSleepTime():Float 
	{
		return startSleepTime;
	}
	
	function get_baseAttackRange():Float 
	{
		return baseAttackRange;
	}
	
	function get_baseDamage():Float 
	{
		return baseDamage;
	}
	
	function get_baseAttackRate():Float 
	{
		return baseAttackRate;
	}
	
	function get_baseSpeed():Float 
	{
		return baseSpeed;
	}
	
}
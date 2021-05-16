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
	public var baseSpeed(get, null):Float;
	public var baseFireRate(get, null):Float;

	public var difficultyLevel(get, null):Int = 1;

	public function new()
	{

	}

	inline function get_startSleepTime():Float
	{
		return startSleepTime;
	}

	inline function get_baseAttackRange():Float
	{
		return baseAttackRange;
	}

	inline function get_baseDamage():Float
	{
		return baseDamage;
	}



	inline function get_baseSpeed():Float
	{
		return baseSpeed;
	}

	inline function get_baseFireRate():Float
	{
		return baseFireRate;
	}

	inline function get_difficultyLevel():Int
	{
		return difficultyLevel;
	}


}
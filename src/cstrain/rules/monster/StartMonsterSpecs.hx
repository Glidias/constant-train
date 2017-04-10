package cstrain.rules.monster;
import cstrain.h2d.SceneSettings;


/**
 * ...
 * @author test
 */
class StartMonsterSpecs extends MonsterSpecs
{

	public function new() 
	{
		super();

		this.baseDamage = 1;
		this.startSleepTime = 10;
		this.baseFireRate = .3;
		this.baseSpeed = .50;
		this.baseAttackRange = .5;
	}
	
}
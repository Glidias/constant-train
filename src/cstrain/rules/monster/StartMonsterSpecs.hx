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
		this.baseAttackRange = 150;
		
		this.baseDamage = 1;
		this.startSleepTime = 10;
		this.baseFireRate = .3;
		this.baseSpeed = .35;
		this.baseAttackRange = .5;
	}
	
}
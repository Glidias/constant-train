package cstrain.rules.monster;
import cstrain.h2d.SceneSettings;


/**
 * Campaign scheme for monster specs. Use this to scale difficulty level up accordingly.
 * @author test
 */
class StartMonsterSpecs extends MonsterSpecs
{

	public function new()
	{
		super();

		this.baseDamage = 1;
		this.startSleepTime = 6;
		this.baseFireRate = .3;
		this.baseSpeed = .50;
		this.baseAttackRange = .5;
	}

	public function dummyAddDifficulty():Void {
		this.baseSpeed += 0.2;
		this.difficultyLevel++;
	}


}
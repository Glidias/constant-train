package cstrain.rules.systems;
import cstrain.rules.world.GameWorld;
import cstrain.core.IBGTrain;
import cstrain.rules.components.Health;
import cstrain.rules.monster.MonsterModel;
import cstrain.rules.world.GameWorld.HealthComp;
import cstrain.rules.world.GameWorld.IBGTrainComp;
import cstrain.rules.world.GameWorld.MonsterModelComp;
import cstrain.vuex.game.GameState.GameVueData;
import ecx.Family;
import ecx.System;
import ecx.Wire;

/**
 * for the hud
 * @author Glidias
 */
class GameVueDataSystem extends System 
{

	public var gameVue:GameVueData;
	
	public function new(gameVue:GameVueData) 
	{
		this.gameVue = gameVue;
	}
	var playerF:Family<IBGTrainComp,HealthComp>;//, train:IBGTrain
	var monsterF:Family<MonsterModelComp>;
	
	var _monster:Wire<MonsterModelComp>;
	var _train:Wire<IBGTrainComp>;
	var _health:Wire<HealthComp>;
	
	override public function update():Void {
		
		for (p in playerF) {
			
			// Not needed, already tracked by listener elsewhere
			//p.data.health;
			//gameVue.health = _health.get(p).value;
			
			// Train
			var train = _train.get(p);
			gameVue.currentProgress = train.currentPosition;
		}
		
		for (p in monsterF) {

			gameVue.updateMonsterPosition(  _monster.get(p) );
		}
	}
}

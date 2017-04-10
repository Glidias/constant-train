package cstrain.rules.world;
import cstrain.core.IBGTrain;
import cstrain.rules.monster.StartMonsterSpecs;
import cstrain.rules.systems.MonsterChasePlayerSystem;
import cstrain.rules.world.GameWorld.UpdateService;
import cstrain.rules.components.*;
import cstrain.rules.monster.MonsterModel;
import cstrain.rules.monster.MonsterSpecs;
import cstrain.rules.systems.GameVueDataSystem;
import cstrain.rules.world.GameWorld.HealthComp;
import cstrain.rules.world.GameWorld.IBGTrainComp;
import cstrain.rules.world.GameWorld.MonsterModelComp;
import cstrain.vuex.game.GameState.GameVueData;

import ecx.Engine;
import ecx.WorldConfig;
import ecx.AutoComp;
import ecx.Entity;
import ecx.Service;
import ecx.Wire;
import ecx.common.EcxCommon;
import ecx.common.systems.SystemRunner;

/**
 * ...
 * @author  Glidias
 */
class GameWorld 
{

	public function new() 
	{
		var config = new WorldConfig();
		
		var update:Int = 1;
	
		var render:Int = 2;
		
		
		// services
		config.include(new EcxCommon());
		config.add( _updateService =  new UpdateService() );
	
		// components
		config.add(_health = new HealthComp());
		config.add(_train = new IBGTrainComp());
		
		config.add(_monster = new MonsterModelComp());
		
		// systems
		config.add( new MonsterChasePlayerSystem(), update );
		config.add( vueSystem = new GameVueDataSystem(null), render );
		
		//world
		world = Engine.createWorld(config, 2);
		
	}
	
	
	var monsterSpecs:MonsterSpecs = new StartMonsterSpecs();
	var vueSystem:GameVueDataSystem;
	var world:ecx.World;
	var _health:HealthComp;
	var _train:IBGTrainComp;
	var _monster:MonsterModelComp;
	var _updateService:UpdateService;
	
	public function commence(train:IBGTrain, vueData:GameVueData):Void {
		// create entities and link components
		var e:Entity;
		
		e = world.create();
		_health.create(e);
		_train.set(e, train);
		
		e = world.create();
		_monster.set(e, new  MonsterModel(monsterSpecs));
		
		
		// link system dependencies
		vueSystem.gameVue = vueData;
	}
	
	public function end():Void {

		for ( i in 1...world.capacity ){  // somehow, re-creating new entities after this doesn't work?
			world.destroy( world.getEntity(i));
		}
		world.invalidate();  // this is needed?
	}

	
	public function update(t:Float):Void {
		//frame.update(t);
		//render.update(t);
		_updateService.update(t);
	}
	
}

class HealthComp extends AutoComp<Health> {}
class MonsterModelComp extends AutoComp<MonsterModel> {}
class IBGTrainComp extends AutoComp<IBGTrain> {}

class UpdateService extends Service {
	var _runner:Wire<SystemRunner>;
	
	public function new() {
		
	}
	
	override  function initialize() {
		trace("Update service inited");
		
	}
	
	
	public function update(dt:Float):Void {
		_runner.updateFrame();
	}
}
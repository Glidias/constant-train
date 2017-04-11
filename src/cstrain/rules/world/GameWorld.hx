package cstrain.rules.world;
import cstrain.core.CardResult;
import cstrain.core.IBGTrain;
import cstrain.core.IRules;
import cstrain.core.OkFlags;
import cstrain.rules.monster.StartMonsterSpecs;
import cstrain.rules.player.PlayerSpecs;
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
 * A basic gameworld/campaign setup.
 * @author  Glidias
 */
class GameWorld 
{

	public function new(playerSpecs:PlayerSpecs=null, monsterSpecs:StartMonsterSpecs=null) 
	{
		 this.monsterSpecs = monsterSpecs != null ? monsterSpecs :  new StartMonsterSpecs();
		 this.playerSpecs =  playerSpecs != null ? playerSpecs : new PlayerSpecs();
		
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
		config.add( monsterChase= new MonsterChasePlayerSystem(), update );
		config.add( vueSystem = new GameVueDataSystem(null), render );
		
		//world
		world = Engine.createWorld(config, 2);
	}
	
	
	public var monsterSpecs:StartMonsterSpecs;
	public var playerSpecs:PlayerSpecs;
	
	var vueSystem:GameVueDataSystem;
	var world:ecx.World;
	var _health:HealthComp;
	var _train:IBGTrainComp;
	var _monster:MonsterModelComp;
	var _updateService:UpdateService;
	
	
	private var playerE:Entity;
	private var health:Health;
	var monsterChase:MonsterChasePlayerSystem;
	
	public function commence(train:IBGTrain, vueData:GameVueData, rules:IRules):Void {
		

		// create entities and link components
		var e:Entity;
		
		e = world.create();
		playerE = e;
		var h = health = _health.create(e);
		h.signalDamaged.add( onPlayerDamaged);
		//h.signalDamaged.add(onTrainDamaged);
		_train.set(e, train);
		
		e = world.create();
		_monster.set(e, new  MonsterModel(monsterSpecs));
		monsterChase.setRules(rules);
		
		
		// link system dependencies
		vueSystem.gameVue = vueData;
		vueData.maxHealth = playerSpecs.maxHealth;
	}
	
	// for now, GameWorld partially processes some conventions/rules related to Monster vs Player..
	// these might be refactored elsewhere later
	function onPlayerDamaged(amount:Float, healthLeft:Float) 
	{
		if (healthLeft <= 0) {
			_health.destroy(playerE);
			world.commit(playerE);
			health.signalDamaged.remove(onPlayerDamaged);
			health = null;
		}
		vueSystem.gameVue.health = healthLeft;
	}
	
	

	
	
	public function end():Void {
		if (health != null) {
			health.signalDamaged.remove(onPlayerDamaged);
			health = null;
		}
		

		
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
	
	
	public inline function update(dt:Float):Void {
		_runner.updateFrame();
	}
}
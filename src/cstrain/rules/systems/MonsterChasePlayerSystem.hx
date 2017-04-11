package cstrain.rules.systems;
import cstrain.core.CardResult;
import cstrain.core.IRules;
import cstrain.core.OkFlags;
import cstrain.rules.world.GameWorld;
import cstrain.core.IBGTrain;
import cstrain.rules.components.Health;
import cstrain.rules.monster.MonsterModel;
import cstrain.rules.world.GameWorld.HealthComp;
import cstrain.rules.world.GameWorld.IBGTrainComp;
import ecx.Family;
import ecx.System;
import ecx.Wire;
import ecx.common.systems.TimeSystem;


// Edge may be a temporary engine to use for now..

/**
 * ...
 * @author Glidias
 */
class MonsterChasePlayerSystem extends System
{
	
	var player:Family<HealthComp, IBGTrainComp>;
	var monsterF:Family<MonsterModelComp>;

	var _health:Wire<HealthComp>;
	var _train:Wire<IBGTrainComp>;
	var _monster:Wire<MonsterModelComp>;
	
	var _timeSystem:Wire<TimeSystem>;
	
	
	public function new() 
	{
		
	}
	
	//var entity : Entity;
	
	override public function update():Void {

		var monster;
		var monsterI = monsterF.iterator();
		if (monsterI.hasNext()) {
			monster = _monster.get( monsterI.next() );
			
			if (_listenFreeze) {
				monster.frozen = true;
				monster.angry = false;
				monster.state = MonsterModel.STATE_NOT_MOVING;
				//trace("Frozen...");
				return;
			}
			else {
				monster.frozen = false;
			}
		}
		else return;

		
		var pit = player.iterator();
		if (pit.hasNext()) {
			var timeDelta:Float = _timeSystem.deltaTime;
			
			var p = pit.next();
			
			// +.5
			var pPos:Float = _train.get(p).currentPosition ; // assumption half of screen offset for player
			var vm = pPos - monster.currentPosition;  // displacement from monster to player position
			
			if (monster.asleepTime > 0) {
				monster.asleepTime -= timeDelta;
			}
			
			if (monster.asleepTime > 0) {
				monster.angry = false;
				monster.state = MonsterModel.STATE_NOT_MOVING;
				///trace("Monster asleep...");
				return;
			}
			
			// chage weapons

			if (monster.weaponCooldownTime > 0)  monster.weaponCooldownTime -= timeDelta;
			
			var maxClamp:Float = abs(vm);
			if ( maxClamp > monster.specs.baseAttackRange) {
				// monster chases player
				monster.angry = false;
				monster.state =  vm > 0 ? MonsterModel.STATE_RIGHT : MonsterModel.STATE_LEFT;
				
			
				monster.currentPosition +=  (vm > 0 ? 1 : -1) * clampMax( monster.specs.baseSpeed * timeDelta, maxClamp);
			}
			else {	// perform monster attack
				monster.angry = true;
				var health  = _health.get(p);
				if ( monster.weaponCooldownTime  <= 0) {  // fire weapon to inflict damage on player
					health.damage(monster.specs.baseDamage + Math.floor(-monster.weaponCooldownTime)*monster.specs.baseFireRate );
					//trace("Hit:"+health.value);
					monster.weaponCooldownTime = monster.specs.baseFireRate;
				}
				// can move about while firing weapon...
				// determine monster movement hover  around player state.
				var START_SCREEN_X:Float =  pPos  - monster.specs.baseAttackRange;
				var BASE_SCREEN_RANGE:Float = monster.specs.baseAttackRange * 2;
				var x:Float = (monster.currentPosition - START_SCREEN_X) / BASE_SCREEN_RANGE;
				if(monster.timer <= 0)
				{
					if(monster.state == MonsterModel.STATE_NOT_MOVING)
					{
						if(x < (160/MONS_W) ) {monster.state = MonsterModel.STATE_RIGHT;}
						else {  monster.state = MonsterModel.STATE_LEFT;}
					}
					else {
						if(x < (50/MONS_W) && monster.state != MonsterModel.STATE_RIGHT) {
							monster.timer = 60/MONS_FRAMER;
						}
						if(x > (300/MONS_W) && monster.state !=  MonsterModel.STATE_LEFT) {
							monster.timer = 60/MONS_FRAMER;
						}
					}
				}
				else {
					monster.state = MonsterModel.STATE_NOT_MOVING;
					if(monster.timer == 40/MONS_FRAMER) {
						monster.dance = 20/MONS_FRAMER;
					}
					monster.timer -= timeDelta; // 1 / MONS_FRAMER ;
				}
				
				
				if(monster.state == MonsterModel.STATE_LEFT) {x -= clampMax(2/BASE_SCREEN_RANGE*timeDelta/MONS_FRAMER, abs(pPos - monster.specs.baseAttackRange - monster.currentPosition)  );}
				if(monster.state == MonsterModel.STATE_RIGHT) {x += clampMax(2/BASE_SCREEN_RANGE*timeDelta/MONS_FRAMER, abs(pPos + monster.specs.baseAttackRange  - monster.currentPosition) );}
				
			
				if(monster.dance > 0)
				{
					if(monster.dance > 15/MONS_FRAMER) {monster.headOffset = 2;}
					else if(monster.dance > 10/MONS_FRAMER) {monster.headOffset = 0;}
					else if(monster.dance > 5/MONS_FRAMER) {monster.headOffset = -2;}
					else {monster.headOffset = 0;}
					monster.dance-= timeDelta;
				}
				
				
				// re-map new x position (if any) for monster
				monster.currentPosition = START_SCREEN_X +  x*BASE_SCREEN_RANGE;

			}
			
			//trace("GOT MONSTER:"+monster.state + " :"+monster.angry);
		}
		else {
			monster.angry = false;
			monster.state = MonsterModel.STATE_NOT_MOVING;
		}
		
	}
	
	static inline var MONS_FRAMER:Float = 30;
	static inline var MONS_W:Float = 320;
	
	static inline function abs(a:Float):Float {
		return a < 0 ? -a : a;
	}
	
	static inline function clampMax(val:Float, max:Float):Float {
		return val >= max ? max : val;
	}
	
	
	// IRules processing...
	// This may be refactored elsewhere if required
	var _rules:IRules;
	var _listenFreeze:Bool = false;
	public function setRules(rules:IRules) 
	{
		if (rules == null) {
		
			if (_rules != null) {
				_rules.onCardResult.remove(onCardResultReceived);
				_rules = null;
			}
			
			return;
		}
		
		if (_rules!= null && _rules != rules) {
			_rules.onCardResult.remove(onCardResultReceived);
		}
		
		_rules = rules;
		_rules.onCardResult.add(onCardResultReceived);
		_listenFreeze = true;
		
	}
	
	function onCardResultReceived(cardResult:CardResult):Void {
		var isFreeze:Bool = false;
		switch( cardResult) {
			case CardResult.NOTHING: return;
		
			case CardResult.OK(flags):
				if ( flags.hasBits( OkFlags.GUESSED_CONSTANT.value|OkFlags.GAME_OVER.value)  ) {
					isFreeze = true;
				}
			default:

		}
		_listenFreeze = isFreeze;
		
		/*
		if (_listenFreeze != isFreeze) {
			
			
			_listenFreeze = isFreeze;
		}
		*/
		
	}
		
	

}
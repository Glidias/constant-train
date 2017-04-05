package cstrain.vuex.game;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.core.GameSettings;
import cstrain.core.IBGTrain;
import cstrain.core.IRules;
import cstrain.core.Penalty;
import cstrain.core.PlayerStats;
import cstrain.core.Polynomial;
import cstrain.rules.components.Health;
import cstrain.rules.monster.MonsterModel;
import cstrain.rules.monster.MonsterSpecs;
import msignal.Signal;
import cstrain.rules.monster.IMonsterSpecs;

/**
 * Vue model
 * @author Glidias
 */
class GameState
{
	// exposed viewmodel properties
	public var cards:Array<Card>;
	public var curCardIndex:Int = 0;
	
	public var playerStats:PlayerStats;
	public var settings:GameSettings;
	
	public var topCard:Card = null;
	public var nextCardBelow:Card = null;

	//public var isPopup:Bool = false;
	public var cardResult:CardResult= null;
	public var polynomial:Polynomial = null;
	public var showExpression:Bool = false;
	
	
	public var delayTimeLeft:Float = 0;
	public var curPenalty:Penalty = null;
	public var penaltySwipeCorrect:Bool = true;
	
	public var chosenSwipe:Int = SWIPE_NONE;
	public static inline var SWIPE_NONE:Int = 0;
	public static inline var SWIPE_LEFT:Int = 1;
	public static inline var SWIPE_RIGHT:Int = 2;

	public var stopsEncountedSoFar:Int = 0;

	public var showInstructions:Bool = false;


	// Post initialization
	public var _chosenCard:Card;
	public var _rules:IRules;
	public var _bgTrain:IBGTrain;
	public var _signalUpdate:Signal1<Float>;
	public var vueData:GameVueData;  // none-vueX BUT reactive vue data 

	public function new(rules:IRules) 
	{
		setupWithRules(rules);
	}
	
	public function setupWithRules(rules:IRules):Void {
		this.cards = rules.getAllCards();
		this.settings = rules.getGameSettings();
		this.playerStats = rules.getPlayerStats();
		
	}
}

class GameVueData {
	
	// player progress
	public var currentProgress:Float = 0;
	// player health
	public var health:Health = null;
	
	// monster
	public var monster:GameMonster = null;
	
	
	public function changeMonster(monster:MonsterModel):Void {
		monster = {
			position:monster.currentPosition,
			specs:monster.specs
		};
	}
	
	public function updateMonsterPosition(monster:MonsterModel):Void {
		if (monster == null) {
			changeMonster(monster);
		}
		monster.currentPosition = monster.currentPosition;
	}
	
	public function new() {

	}
}

typedef GameMonster =  {
	var position:Float;
	var specs:IMonsterSpecs;
}
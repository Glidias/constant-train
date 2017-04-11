package cstrain.vuex.store;
import cstrain.core.IBGTrain;
import cstrain.core.IRules;
import cstrain.rules.monster.StartMonsterSpecs;
import cstrain.rules.player.PlayerSpecs;
import cstrain.vuex.components.BasicTypes;
import cstrain.vuex.game.GameMenuActions;
import cstrain.vuex.game.GameModule;
import cstrain.vuex.game.GameState;
import haxevx.vuex.core.IStoreGetters;
import haxevx.vuex.core.VxStore;
import cstrain.vuex.store.Payloads.SaveGameData;

/**
 * ...
 * @author Glidias
 */
class GameStore extends VxStore<GameStoreState>
{

	@:action static var menuActions:GameMenuActions;
	@:mutator static var mutator:GameStoreMutator;
	
	@:module @:manual public var game:GameModule;
	
	
	
	public var getters(default,never):StoreGetters;
	
	public function new() 		 //rules:IRules, bgTrain:IBGTrain=null
	{
		state = new GameStoreState();
		
		//game = new GameModule(rules, bgTrain);
		
	}

	
}

class StoreGetters implements IStoreGetters<GameStoreState> {
	public function new() {
		
	}
	public static function Get_isTouchBased(state:GameStoreState):Bool {
		return TouchVUtil.IS_TOUCH_BASED;
	}
}

class GameStoreState {
	public function new() {
		
	}
	@:module public var game:GameState;
	
	
	public var _savedLevelStats(get, null):GameStoreLevelStats;
	public function saveLevel(lastPlayer:PlayerSpecs, lastMonster:StartMonsterSpecs):Void {
		_savedLevelStats =  {
			LAST_MONSTER_SPECS:lastMonster,
			LAST_PLAYER_SPECS:lastPlayer
		};
	}
	inline function get__savedLevelStats():GameStoreLevelStats 
	{
		return _savedLevelStats;
	}
	

}

typedef GameStoreLevelStats = SaveGameData;
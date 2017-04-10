package cstrain.vuex.store;
import cstrain.core.IBGTrain;
import cstrain.core.IRules;
import cstrain.vuex.components.BasicTypes;
import cstrain.vuex.game.GameMenuActions;
import cstrain.vuex.game.GameModule;
import cstrain.vuex.game.GameState;
import haxevx.vuex.core.IStoreGetters;
import haxevx.vuex.core.VxStore;

/**
 * ...
 * @author Glidias
 */
class GameStore extends VxStore<GameStoreState>
{

	@:action static var menuActions:GameMenuActions;
	
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
	

}
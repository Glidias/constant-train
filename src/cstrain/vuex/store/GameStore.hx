package cstrain.vuex.store;
import cstrain.core.IBGTrain;
import cstrain.core.IRules;
import cstrain.vuex.components.BasicTypes;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.game.GameModule;
import cstrain.vuex.game.GameMutator;
import cstrain.vuex.game.GameState;
import cstrain.vuex.store.GameStore.GameStoreState;
import haxevx.vuex.core.IGetters;
import haxevx.vuex.core.IStoreGetters;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxStore;

/**
 * ...
 * @author Glidias
 */
class GameStore extends VxStore<GameStoreState>
{

	
	@:module @:manual public var game:GameModule;
	public var getters(default,never):StoreGetters;
	
	public function new(rules:IRules, bgTrain:IBGTrain=null) 		
	{
		state = new GameStoreState();
		
		
		game = new GameModule(rules, bgTrain);
		
		
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
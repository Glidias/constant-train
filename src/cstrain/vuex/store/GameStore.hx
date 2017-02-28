package cstrain.vuex.store;
import cstrain.core.IRules;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.game.GameModule;
import cstrain.vuex.game.GameMutator;
import cstrain.vuex.game.GameState;
import cstrain.vuex.store.GameStore.GameStoreState;
import haxevx.vuex.core.VxStore;

/**
 * ...
 * @author Glidias
 */
class GameStore extends VxStore<GameStoreState>
{

	
	@:module @:manual public var game:GameModule;
	
	public function new(rules:IRules) 		
	{
		state = new GameStoreState();
		
		game = new GameModule(rules);
		
	}
	
	
	
}


class GameStoreState {
	public function new() {
		
	}
	@:module public var game:GameState;

}
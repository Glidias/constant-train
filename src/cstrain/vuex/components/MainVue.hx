package cstrain.vuex.components;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.VxComponent;

/**
 * ...
 * @author Glidias
 */
class MainVue extends VxComponent<GameStore, NoneT, NoneT>
{

	public function new() 
	{
		super();
	}
	
	override public function Components():Dynamic<VComponent<Dynamic,Dynamic>>  {
		return [
			GameView.TAG => new GameView(),
			GameMenu.TAG => new GameMenu()
		];
	}
	
	
	var gameInProgress(get, never):Bool;
	function get_gameInProgress():Bool {
		return store.state.game != null;
	}
	
	
	override public function Template():String {
		return '
			<div>
				<${GameMenu.TAG} v-if="!gameInProgress" />
				<${GameView.TAG} v-if="gameInProgress"/>
			</div>
		';
	}
	
	
}


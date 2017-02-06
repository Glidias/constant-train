package cstrain.vuex.game;
import haxevx.vuex.core.IMutator;

/**
 * ...
 * @author Glidias
 */
class GameMutator implements IMutator<GameState>
{

	public static function Restart(g:GameState):Void {
		g._rules.restart();
		
		g.cards = g._rules.getAllCards();
	}
	
	function restart(g:GameState):Void {
		GameMutator.Restart(g);
	}
	
	function penalize(g:GameState):Void {
		trace("Penalizing");
	}
	
	//context:IVxContext1<GameState>
	function swipe(state:GameState, isRight:Bool):Void {
		state._rules.playCard(isRight);
	}

	
}
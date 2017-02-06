package cstrain.vuex.game;
import haxevx.vuex.core.IAction;
import haxevx.vuex.core.IVxContext;
import haxevx.vuex.core.IVxContext.IVxContext1;
import haxevx.vuex.core.NoneT;

/**
 * ...
 * @author Glidias
 */
class GameActions implements IAction<GameState, NoneT>
{

	@:mutator static var mutator:GameMutator;
	
	function swipe(context:IVxContext, isRight:Bool):Void {
		mutator._swipe(context, isRight);
	}
	
}
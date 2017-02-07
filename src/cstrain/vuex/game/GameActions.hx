package cstrain.vuex.game;
import cstrain.core.CardResult;
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

	//static inline var DELAY_TIME:Float = 2;
	@:mutator static var mutator:GameMutator;
	
	function swipe(context:IVxContext1<GameState>, isRight:Bool):Void {
		//trace("Swiping: " +(isRight ? "right" : "left") );
		
		var result = context.state._rules.playCard(isRight);
		switch( result) {
			case CardResult.GUESS_CONSTANT(guessCard, wildGuessing):
				// show popup mutation
				mutator._setPopupCard(context);  // guessCard already encapcsulted within IRules api topmost card
				mutator._resume(context);
			case CardResult.PENALIZE(penalty):
				//penalty.delayNow;
				if (penalty.delayNow != null) {
					mutator._setDelay(context, penalty.delayNow);
				}
				
				// if testing only
				mutator._resume(context);
		
			case CardResult.OK:
					// play OK sound, close any popups, etc.
					mutator._resume(context);
					
			default:
				trace("Uncaught case: " + result);
		}
		
		mutator._traceCardResult(context, result);
	
	}
	
	
	
}
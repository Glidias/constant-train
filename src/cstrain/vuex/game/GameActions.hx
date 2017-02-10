package cstrain.vuex.game;
import cstrain.core.CardResult;
import cstrain.core.PenaltyDesc;
import haxe.Timer;
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
		mutator._notifySwipe(context, isRight ? GameState.SWIPE_RIGHT : GameState.SWIPE_LEFT);
		
		var result = context.state._rules.playCard(isRight);
		switch( result) {
			case CardResult.GUESS_CONSTANT(guessCard, wildGuessing):
				// show popup mutation
				//mutator._setPopupCard(context);  // guessCard already encapcsulted within IRules api topmost card
				mutator._resume(context);
			case CardResult.PENALIZE(penalty):
				mutator._setPenalty(context, penalty);
				//penalty.delayNow;
				if (penalty.delayNow != null  ) {
					var calcTime:Float = penalty.delayNow * context.state.settings.penaltyDelayMs;
					mutator._setDelay(context,calcTime );
					
					if (penalty.delayNow > 0) {
						Timer.delay( function() {
							mutator._setDelay(context, 0);
							mutator._resume(context);
						}, Std.int(calcTime) );
					}
					else {
						mutator._resume(context);
					}
				}
				
				switch( penalty.desc) {
					case PenaltyDesc.CLOSER_GUESS(_):
						mutator._setPenaltySwipeCorrect(context, true);
					default:
						mutator._setPenaltySwipeCorrect(context, false);
				}
		
			case CardResult.OK:
					// play OK sound, close any popups, etc.
					//mutator._setPopupCard(context,false);
					mutator._setPenalty(context, null);
					mutator._updateProgress(context);
					mutator._resume(context);
			case CardResult.NOT_YET_AVAILABLE(timeLeft, penaltyTime):
				// beep
				trace("Not yet available to swipe!:"+[timeLeft, penaltyTime]);
			
			case CardResult.GAMEOVER_OUTTA_CARDS:
				mutator._traceCardResult(context, result);
				
			default:
				trace("Uncaught case: " + result);
		}
		
			//mutator._traceCardResult(context, result);
	
	}
	
	
	
	
	
}
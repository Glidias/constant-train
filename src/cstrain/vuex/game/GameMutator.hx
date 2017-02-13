package cstrain.vuex.game;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.core.Penalty;
import cstrain.core.Polynomial;
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
	
	function notifySwipe(state:GameState, swipeState:Int ):Void {
		state.chosenSwipe = swipeState;
		if (swipeState != GameState.SWIPE_NONE) state._chosenCard = state.topCard;
		
	}
	
	function updateProgress(state:GameState):Void {
		state.curCardIndex = state._rules.getDeckIndex();
	}
	
	function setPenalty(state:GameState, penalty:Penalty):Void {
		state.curPenalty = penalty;
	}
	function setPenaltySwipeCorrect(state:GameState, correct:Bool):Void {
		state.penaltySwipeCorrect = correct;
	}
	
	function setDelay(state:GameState, delay:Float):Void {
		state.delayTimeLeft = delay;
	}
	
	
	function traceCardResult(state:GameState, result:CardResult):Void {
		state.cardResult = result;
	}
	
	
	function resume(state:GameState):Void {

		
		state.penaltySwipeCorrect = true;
		state.delayTimeLeft  = 0;
		

		state.topCard = state._rules.getTopmostCard();
		state._rules.getNextCardBelow();
		updateExpression(state);
		
	}
	
	inline function updateExpression(state:GameState):Void {
		state.polynomial = Polynomial.Copy( state._rules.getPolynomial() );
	}
	
	function showOrHideExpression(state:GameState, ?showExpression:Bool):Void {
		if (showExpression == null) showExpression = !state.showExpression;
		state.showExpression = showExpression;
	}
	
	

	
}
package cstrain.vuex.game;
import cstrain.core.CardResult;
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
	
	function setPopupCard(state:GameState, isPopup:Bool = true):Void {
		
		state.isPopup = isPopup;

	}
	
	function setDelay(state:GameState, delay:Float):Void {
		state.delayTimeLeft = delay;
	}
	
	
	function traceCardResult(state:GameState, result:CardResult):Void {
		state.cardResult = result;
	}
	
	
	function resume(state:GameState):Void {

		state.topCard = state._rules.getTopmostCard();
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
package cstrain.vuex.game;
import cstrain.core.Polynomial;
import haxevx.vuex.core.IGetters;
import haxevx.vuex.core.NoneT;

/**
 * ...
 * @author Glidias
 */
class GameGetters implements IGetters<GameState, NoneT>
{
	public function new() {
		
	}
	public static function Get_polynomialExpr(state:GameState):String {
		return state.showExpression ? state.polynomial != null ? Polynomial.PrintOut( state.polynomial, "n") : ".." : "";
	}
	
}
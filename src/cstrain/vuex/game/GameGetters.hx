package cstrain.vuex.game;
import cstrain.core.Card;
import cstrain.core.Penalty;
import cstrain.core.PenaltyDesc;
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
		return state.showExpression ? state.polynomial != null ? Polynomial.PrintOut( state.polynomial, "n", true) : ".." : "";
	}
	
	public static inline function Get_simpleChosenNumber(state:GameState):Int {
		return state._chosenCard != null ?  (state.chosenSwipe == GameState.SWIPE_RIGHT ? state._chosenCard.virtualRight.value : state._chosenCard.value ) : GameState.SWIPE_NONE;
	}
	
	public static inline function Get_notChosenNumber(state:GameState):Int {
		return state._chosenCard != null ?  (state.chosenSwipe == GameState.SWIPE_RIGHT ? state._chosenCard.value : state._chosenCard.virtualRight.value ) : GameState.SWIPE_NONE;
	}
	
	public static inline function Get_isPenalized(state:GameState):Bool {
		return state.curPenalty != null;
	}
	
	
	public static inline function Get_isPopupChoicing(state:GameState):Bool {
		return state.topCard != null && state.topCard.operator == Card.OPERATION_EQUAL;
	}
	public static inline function Get_swipedCorrectly(state:GameState):Bool {

		return state.curPenalty != null ? state.penaltySwipeCorrect : true;
	}
	
	
	
	public static inline function Get_totalCards(state:GameState):Int {

		return state.cards  != null ? state.cards.length : 0;
	}
	public static inline function Get_curCardIndex(state:GameState):Int {

		return state.curCardIndex;// : 0;
	}
	
	public static function Get_simplePenaltyPhrase(state:GameState):String {
		var penalty:Penalty = state.curPenalty;
		if (penalty == null) return "Unknown reason delay!";
		switch(penalty.desc) {
			case PenaltyDesc.MISSED_STOP:
				return "You missed a stop!";
			case PenaltyDesc.LOST_IN_TRANSIT:
				return "Lost in transit...";
			case PenaltyDesc.WRONG_CONSTANT:
				return "Oops, Guessed constant wrongly. The answer is "+Get_notChosenNumber(state) +"!";
			case PenaltyDesc.CLOSER_GUESS(answerHigher):
				return "You guessed "+Get_simpleChosenNumber(state)+", which is a closer answer. Guess " + (answerHigher ? "higher" : "lower") + "!";
			case PenaltyDesc.FURTHER_GUESS(answerHigher):
				return "You guessed "+Get_simpleChosenNumber(state)+", which is a further answer. Guess " + (answerHigher ? "higher" : "lower") + "!";
			default:
				
				
		}
		
		return "Unknown penalty reason delay!";
	}
	
}
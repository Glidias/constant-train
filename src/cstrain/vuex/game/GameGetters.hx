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

	public static inline function Get_difficultyLevel(state:GameState):Int {
		return state._monsterSpecs != null ? state._monsterSpecs.difficultyLevel : 0;
	}

	public static inline function Get_isPenalized(state:GameState):Bool {
		return state.curPenalty != null;
	}
	public static inline function Get_cardsLeft(state:GameState):Int {
		return Get_totalCards(state) - state.curCardIndex;
	}

	// assumption made state.vueData != null, remmber to use v-if if necessary
	public static inline function Get_healthInt(state:GameState):Int {
		return  state.vueData.health >= 1 ? Std.int(state.vueData.health) : state.vueData.health > 0 ?  1 : 0;
	}

	public static inline function Get_healthRatio(state:GameState):Float {
		return Get_healthInt(state) / state.vueData.maxHealth;
	}


	public static inline function Get_isAliveHP(state:GameState):Bool {
		return Get_healthInt(state) > 0;
	}


	public static inline function Get_isPopupChoicing(state:GameState):Bool {
		return state.topCard != null && state.topCard.operator == Card.OPERATION_EQUAL;
	}

	public static function Get_isAtStop(state:GameState):Bool {
		var caseNorm:Bool = state.topCard != null && state.topCard != state.cards[state.curCardIndex];
		var casePenalized:Bool = state.topCard != null ? state.topCard.operator == Card.OPERATION_EQUAL : false;
		return Get_isPenalized(state) ? casePenalized :  caseNorm;
	}


	public static inline function Get_isAtStopReadyToGo(state:GameState):Bool {
		return Get_isAtStop(state) && !Get_isPopupChoicing(state) && !Get_isPenalized(state);
	}






	public static  function Get_isMainDeckCard(state:GameState):Bool {
		return state.topCard == (state.curCardIndex <  state.cards.length ? state.cards[state.curCardIndex] : null);
	}


	public static function Get_progressUnit(state:GameState):Float {
		return 1/Get_totalCards(state);
	}
	public static function Get_progress(state:GameState):Float {
		return state.vueData.currentProgress / state.cards.length;
	}
	public static function Get_monsterProgress(state:GameState):Float {
		return state.vueData != null && state.vueData.monster != null ?   state.vueData.monster.position / state.cards.length : 0;
	}
	public static function Get_monsterRangeScale(state:GameState):Float {
		return state.vueData != null && state.vueData.monster != null ?   state.vueData.monster.range : 1;
	}





	public static inline function Get_swipedCorrectly(state:GameState):Bool {

		return state.curPenalty != null ? state.penaltySwipeCorrect : true;
	}

	public static inline function Get_showInstructions(state:GameState):Bool {

		return  state.showInstructions;
	}

	public static inline function Get_totalCards(state:GameState):Int {

		return state.cards  != null ? state.cards.length : 0;
	}
	public static inline function Get_curCardIndex(state:GameState):Int {
		return state.curCardIndex;// : 0;
	}

	/*

	public static  function Get_beltOfMainCards(state:GameState):Array<{card:Card}> {
		var arr:Array<{card:Card}> = [];

		var topCard:Card =  state.topCard;
		var belowCard:Card = state.nextCardBelow;
		var isPopingUp:Bool = Get_isPopupChoicing(state) || Get_isPenalized(state);


		while (--i > -1) {
			arr.push({card:state.cards[i]});
		}
		return arr;
	}

	public static  function Get_beltOfPopupCards(state:GameState):Array<{card:Card}> {

		return [];
	}
	*/

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
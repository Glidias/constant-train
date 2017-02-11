package cstrain.vuex.components;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.vuex.game.GameMutator;
import cstrain.vuex.game.GameState;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.VxComponent;

/**
 * ...
 * @author Glidias
 */
class GameView extends VxComponent<GameStore, NoneT, NoneT>
{

	public function new() 
	{
		super();
	}
	
	static inline var Comp_CardView:String = "CardView";
	
	override public function Components():Dynamic<VComponent<Dynamic,Dynamic>>  {
		return [
			Comp_CardView => new CardView()
		];
	}
	
	var currentCard(get, never):Card;
	var cardResult(get, never):CardResult;
	
	@:mutator static var mutator:GameMutator;
	
	override public function Created():Void {
		mutator._resume(store);
		
	}
	
	function toggleExpression() {
		
		mutator._showOrHideExpression(store);
	}
	
	var polyexpression(get, never):String;
	var toggleExprLabel(get, never):String;

	
	override public function Template():String {
		return '
			<div class="gameview">
				The Constant Train :: Polynomial Express
				<hr/>
				<p>Swipe right to infer result as constant to stop the train!<br/>Swipe left to infer result as variable to move along!</b>
				<$Comp_CardView :currentCard="currentCard"></$Comp_CardView>
				<div class="traceResult" v-if="cardResult">
					<p>{{ cardResult }}</p>
				</div>
				<div class="xpression" style="font-style:italic" v-html="polyexpression"></div>
				<br/>
				<button class="cheat" v-on:click="toggleExpression()">{{ toggleExprLabel }} expression</button>
			</div>
		';
	}
	

	function get_currentCard():Card 
	{
		return store.state.game.topCard;
	}
	function get_cardResult():CardResult 
	{
		return store.state.game.cardResult;
	}
	function get_toggleExprLabel():String 
	{
		return store.state.game.showExpression ? "Hide" : "Show";
	}
	
	function get_polyexpression():String 
	{
		return store.game.gameGetters.polynomialExpr;
	}
	
	
	
}
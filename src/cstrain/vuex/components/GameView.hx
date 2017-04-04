package cstrain.vuex.components;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.vuex.components.BasicTypes.TouchVUtil;
import cstrain.vuex.game.GameMenuActions;
import cstrain.vuex.game.GameMutator;
import cstrain.vuex.game.GameState;
import cstrain.vuex.store.GameStore;
import haxe.Json;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.VxComponent;

/**
 * ...
 * @author Glidias
 */
@:build(haxevx.vuex.core.VCSS.buildModuleStyleFromFile(null, "scss") )
class GameView extends VxComponent<GameStore, NoneT, NoneT>
{

	public function new() 
	{
		super();
	}
	
	public static inline var Comp_CardView:String = "CardView";
	public static inline var Comp_PopupCardView:String = "PopupCardView";
	
	override public function Components():Dynamic<VComponent<Dynamic,Dynamic>>  {
		return [
			Comp_CardView => new CardView(),
			Comp_PopupCardView => new PopupCardView(),
			TrainProgressBarView.NAME => new TrainProgressBarView() 
		];
	}
	
	public static inline var TAG:String = "GameView";
	
	var currentCard(get, never):Card;
	var cardResult(get, never):CardResult;
	
	@:mutator static var mutator:GameMutator;
	@:action static var menuAction:GameMenuActions;
	
	

	override public function Created():Void {
		mutator._resume(store);
		//trace("CREATED");
		store.state.game._signalUpdate.add( handleUpdate );

	}
	
	// This should be factored out to some other controller implementation..but where?
	function handleUpdate(dt:Float) {
		store.state.game.vueData.currentProgress = store.state.game._bgTrain.currentPosition;
	}
	
	function toggleExpression() {
		
		mutator._showOrHideExpression(store);
	}
	
	var polyexpression(get, never):String;
	var toggleExprLabel(get, never):String;
	
	var showInstructions(get, never):Bool;
	function get_showInstructions():Bool 
	{
		return store.game.gameGetters.showInstructions;
	}
	
	function toggleInstructions():Void {
		mutator._toggleInstructions(store);
	
	}
	
	var helpBtnShown(get, never):Bool;
	function get_helpBtnShown():Bool {
		return store.state.game.delayTimeLeft ==  0;
	}
	
	var showGameOver(get, never):Bool;
	function get_showGameOver():Bool {
		return store.game.gameGetters.cardsLeft <=0;
	}
	
	function quitGame():Void {

		menuAction._quitGame(store, _vStore);
	}

	
	override public function Template():String {
		
		
		#if !production
		var cheatBtn:String = '<${TouchVUtil.TAG} tag="button" v-on:tap="toggleExpression()" style="position:absolute;top:10px;right:0">{{ toggleExprLabel }} expression</${TouchVUtil.TAG}>';
		#else
		var cheatBtn:String = '';
		#end
		
		/*
		 * <div v-show="showInstructions">
					The Constant Train :: Polynomial Express <span style="font-size:0.5em">{{ $$store.getters.isTouchBased ? "(T)" : "(D)" }}</span>
					<hr/>
					<p>Swipe right to infer result as constant to stop the train!<br/>Swipe left to infer result as variable to move along!</p>
				</div>
				*/
		
		return '
			<div class="${STYLE.gameview}">
				<${TrainProgressBarView.NAME} />
				<${TouchVUtil.TAG} tag="a" class="${STYLE.quitbtn}" style="cursor:pointer" v-on:tap="quitGame()" >
					[quit]
				</${TouchVUtil.TAG}>
				<keep-alive>
					<${Comp_CardView}></${Comp_CardView}>
				</keep-alive>
				<${Comp_PopupCardView}></${Comp_PopupCardView}>
				<div class="${STYLE.blocker}" v-show="showInstructions" :class="{\'${STYLE.showInstruct}\':showInstructions}"></div>
				<div v-if="cardResult">
					<p>{{ cardResult }}</p>
				</div>
				<div class="${STYLE.xpression}" style="font-style:italic" v-html="polyexpression"></div>
				<br/>
				${cheatBtn}
				<div class="${STYLE.gameover}" v-show="showGameOver">
					<h1>Congratulations!</h1>
					<h2>${"You've finished the race!"}</h2>
				</div>
			</div>
		';
	}
	
	//

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
package cstrain.vuex.components;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.vuex.components.BasicTypes.TouchVUtil;
import cstrain.vuex.game.GameMenuActions;
import cstrain.vuex.game.GameMutator;
import cstrain.vuex.store.GameStore;
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
		//store.state.game._gameWorld.update
		store.state.game._signalUpdate.add(store.state.game._gameWorld.update  );
	}
	

	private function myUpdate(dt:Float):Void {
	//	store.state.game.vueData.currentProgress = store.state.game._bgTrain.currentPosition;
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
		return store.game.gameGetters.cardsLeft <=0 && store.state.game.cardsOutDetected;  // todo: put this in getter convention.
	}
	
	function quitGame():Void {

		menuAction._quitGame(store, _vStore);
	}
	
	@:computed function get_gotHealth():Bool {
		return store.state.game.vueData != null;
	}

	
	@:computed function get_HPStyle():Dynamic {
		return {
			transform:"scaleY("+(store.game.gameGetters.healthRatio)+")"
		}
	}
	
	@:computed function get_healthAmt():Int {
		return store.game.gameGetters.healthInt;
	}
	
	@:computed function get_isAlive():Bool {
		return store.game.gameGetters.isAliveHP;
	}
	
	override public function Template():String {
		
		
		#if !production
		var cheatBtn:String = '<${TouchVUtil.TAG} tag="button" class="cheatingbtn" v-on:tap="toggleExpression()" style="position:absolute;top:100vh;transform:translateY(-40px);left:0;font-size:9px">{{ toggleExprLabel }} expression</${TouchVUtil.TAG}>';
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
					<${Comp_CardView} v-show="isAlive"></${Comp_CardView}>
				</keep-alive>
				<${Comp_PopupCardView} v-show="isAlive"></${Comp_PopupCardView}>
				<div class="${STYLE.healthBar}" v-if="gotHealth">
					<div class="${STYLE.healthLabel}">{{  healthAmt }}</div>
					<div class="${STYLE.meter}" v-bind:style="HPStyle"></div>
				</div>
				<div class="${STYLE.blocker}" v-show="showInstructions" :class="{\'${STYLE.showInstruct}\':showInstructions}"></div>
				<div v-if="cardResult">
					<p>{{ cardResult }}</p>
				</div>
				<div class="${STYLE.xpression}" style="font-style:italic" v-html="polyexpression"></div>
				<br/>
				${cheatBtn}
				<div class="${STYLE.gameover}" v-show="showGameOver && isAlive">
					<div class="${STYLE.anim}">
						<h1>Congratulations!</h1>
						<h2>You\'ve finished the race!</h2>
					</div>
				</div>
				<div class="${STYLE.gameover}" v-show="!isAlive">
					<div class="${STYLE.anim}">
						<h1>Game Over!</h1>
						<h2>You died!</h2>
					</div>
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
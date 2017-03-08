package cstrain.vuex.components;
import cstrain.core.Card;
import cstrain.core.CardResult;
import cstrain.vuex.components.CardView.CardViewState;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.store.GameStore;
import gajus.swing.Swing.SwingCard;
import gajus.swing.Swing.SwingCardEvent;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.VxComponent;
import cstrain.vuex.components.BasicTypes;
import js.Promise;

/**
 * ...
 * @author Glidias
 */
class PopupCardView extends BaseCardView
{

	
	@:action static var actions:GameActions;
	
	public function new() 
	{
		super();
	}
	
	override function onThrowOut(e:SwingCardEvent):Promise<CardResult> {

		
		return super.onThrowOut(e);

	}
	
	/*
	inline function myData():CardViewState {
		return untyped _vData;
	}
	*/
	
	
	
	
	
	///*
	override public function Data():SwingStackData {
		return BaseCardView.getBeltData(7);
	}
	//*/
	
	
	function getCardForIndex(i:Int):Card {
		var gotDelay:Bool = store.state.game.delayTimeLeft != 0 ;
		var topCardMatch:Bool =  this.topCardIndex != i;
		return gotDelay ? null   :   topCardMatch ? this.topCardIndex - 1 != i ? null :  null : store.state.game.topCard;
	}
	
	var isPopupChoicing(get, never):Bool;
	function get_isPopupChoicing():Bool {
		return store.game.gameGetters.isPopupChoicing;
	}
	
	static inline var BELT_AMOUNT:Int = 7;
	
	

	
	
	override public function Template():String {
		return '
			<div class="popup-cardview" :class="{shown:isPopupChoicing}">
				<h4 style="position:absolute;bottom:5px;right:5px">{{ topCardIndex}}</h4>
				<ul class="cardstack">
					<${BaseCardView.Comp_Card} v-for="(ref, i) in refCards" :card="getCardForIndex(i)" :stack="$$data._stack" :index="i" :key="i">{{i}}</${BaseCardView.Comp_Card}>
				</ul>
			</div>
		';
	}
	
}
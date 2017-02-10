package cstrain.vuex.components;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import cstrain.core.Card;

/**
 * ...
 * @author Glidias
 */
class CardView extends VxComponent<GameStore, NoneT, CardViewProps>
{

	public function new() 
	{
		super();
		
	}
	
	var cardCopy(get, never):String;
	
	@:action  static var actions:GameActions;
	
	function swipe(isRight:Bool):Void {
		actions._swipe(store, isRight);
	}
		
	override public function Template():String {
		return '
			<div class="cardview">
				<h3>Swipe</h3>
				<div class="card" v-if="currentCard">
					{{ cardCopy }} 
					<br/>
					
				</div>
				<button v-on:click="swipe(false)">Left</button>
				<button v-on:click="swipe(true)">Right</button>
			</div>
		';
	}
	
	function get_cardCopy():String 
	{
		return Card.canOperate(this.currentCard.operator) ?  getCardCopy(this.currentCard) : getCardCopy(this.currentCard) + " :: " + getCardCopy(this.currentCard.virtualRight);
	}
	
	static inline function getCardCopy(card:Card):String {
		return Card.stringifyOp(card.operator) + ( card.isVar ? "n" : card.value+"" ) ;
	}
	
	
	
}

typedef CardViewProps = {
	public var currentCard:Card;
}
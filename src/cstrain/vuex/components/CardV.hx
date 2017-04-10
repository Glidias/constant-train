package cstrain.vuex.components;
import cstrain.core.Polynomial;
import cstrain.vuex.components.BasicTypes.BuiltVUtil;
import gajus.swing.Swing;
import cstrain.core.Card;
import gajus.swing.Swing.SwingCard;
import gajus.swing.Swing.SwingStack;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import js.html.Event;

/**
 * ...
 * @author Glidias
 */
@:build(haxevx.vuex.core.VCSS.buildModuleStyleFromFile(null, "scss") )
class CardV extends VComponent<SwingCardRef, CardProps>
{

	public static inline var CompName:String = "CardV";
	
	public function new() 
	{
		super();
	

	}
	
	override public function Data():SwingCardRef {
		return {
			
		}
	}
	
	override public function Mounted():Void {
	
		_vData._card = this.stack.createCard(_vEl);
	}
	


	function testReturn(event:Event):Bool {
		
		return false;
	}
	
	var cardCopy(get, never):String;
	function get_cardCopy():String 
	{
		//var delayTimeLeft:Int = this.secondsLeft;
		var regularCopy:String = this.card != null ?    Card.canOperate(this.card.operator) ?  getCardCopy(this.card) : getCardCopy(this.card) + " :: " + getCardCopy(this.card.virtualRight)    : "?";
		//var penaltyPhrase:String = store.game.gameGetters.simplePenaltyPhrase + ": "+ this.secondsLeft;
		
		/*
		if (this.store.state.game.delayTimeLeft > 0) {
			return penaltyPhrase;
		}
		*/
		return regularCopy;
	
	}
	
	
	public static  function getCardCopy(card:Card):String {
		var isPolynomialOfVars:Bool =  card.isPolynomial();  // required to factor out condition for reactivity!
		
		var cardIsVar:Bool = card.isVar;
		return  ( Card.canOperate(card.operator) ?  Card.stringifyOp(card.operator) : "") + ( isPolynomialOfVars ?  "("+Polynomial.PrintOut(card.getPolynomial(), "n", true)+")" :  ( card.operator == Card.OPERATOR_DERIVATIVE ? "" : cardIsVar ? "n" : card.value+"" )) ;
	}

	

	override public function Template():String {
		return '
			<li class="${STYLE.card}" :index="index"><span style="font-size:9px; color:#aaaaaa" v-show="${BuiltVUtil.isProductionStrNot()}">{{index}},<slot></slot>:</span>&nbsp;<span v-html="cardCopy"></span></li>
		';
	}
}

typedef CardProps =  {
	@:optional var card:Card;
	var stack:SwingStack;
	var index:Int;
}

typedef SwingCardRef = {
	@:optional var _card:SwingCard;

}
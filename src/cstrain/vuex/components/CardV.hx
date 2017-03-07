package cstrain.vuex.components;
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
class CardV extends VComponent<SwingCardRef, CardProps>
{

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
	
	var cardCopy(get, never):String;
	function get_cardCopy():String {
		return this.card != null ? CardView.getCardCopy(this.card) : "";
	}
	
	function onClickTest(event:Event):Void {
		
			//trace("CLICK TO EMIT:"+_props.index);
		_vEmit("clickTest", _props.index);
	}
	
	function testReturn(event:Event):Bool {
		
		return false;
	}

	override public function Template():String {
		return '
			<li class="card"><slot></slot>:{{card!= null ? "GOt card"+this.card.value : "NONE" }}<a href="javascript:;" v-on:click="onClickTest">+</a></li>
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
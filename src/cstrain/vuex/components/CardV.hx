package cstrain.vuex.components;
import cstrain.core.Card;
import cstrain.vuex.swing.Swing.SwingStack;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;

/**
 * ...
 * @author Glidias
 */
class CardV extends VComponent<NoneT, CardProps>
{

	public function new() 
	{
		super();
	}
	
	override public function Mounted():Void {
	
		this.stack.createCard(_vEl);
	}

	override public function Template():String {
		return '
			<li class="card"><slot></slot></li>
		';
	}
}

typedef CardProps =  {
	@:optional var card:Card;
	var stack:SwingStack;
}
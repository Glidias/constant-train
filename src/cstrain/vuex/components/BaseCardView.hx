package cstrain.vuex.components;
import cstrain.core.CardResult;
import cstrain.vuex.game.GameActions;
import cstrain.vuex.store.GameStore;
import gajus.swing.Swing;
import gajus.swing.Swing.SwingCard;
import gajus.swing.Swing.SwingCardEvent;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.VxComponent;
import cstrain.vuex.components.BasicTypes;
import js.html.HtmlElement;

/**
 * ...
 * @author Glidias
 */
@:build(haxevx.vuex.core.VCSS.buildModuleStyleFromFile(null, "scss") )
class BaseCardView extends VxComponent<GameStore, SwingStackData, NoneT>
{

	public function new() 
	{
		super();
	}
	
	override public function Created():Void {
		
		_vData._stack = Swing.Stack({
			throwOutConfidence:confidenceHandler
			,	maxRotation: 22,
			//maxThrowOutDistance: 400,
			//minThrowOutDistance: 400,
			rotation:rotationHandler
			
		});
		_vData._stack.on("throwout", onThrowOut);
		_vData._stack.on("throwoutend", onThrowOutEnd);

	}

	public static function getEmptyBelt(amount:Int):Array<RefCard> {
		var arr:Array<RefCard> = [];
		for ( i in 0...amount) {
			arr[i] = {card:null}
		}
		
		return arr;
	}

	
	function rotationHandler(coordinateX:Float, coordinateY:Float, element:HtmlElement, maxRotation:Float):Float {
		var horizontalOffset = Math.min(Math.max(coordinateX / element.offsetWidth, -1), 1);
		  var verticalOffset = (coordinateY > 0 ? 1 : -1) * Math.min(Math.abs(coordinateY) / 100, 1);
		  var rotation = horizontalOffset * verticalOffset * maxRotation;

		  return rotation + 15*horizontalOffset;
	}
	
	
	override public function Components():Dynamic<VComponent<Dynamic,Dynamic>>  {
		return [
			'${CardV.CompName}' => new CardV()
		];
	}
	
	function confidenceHandler(xOffset:Float, yOffset:Float, element:HtmlElement):Float {
		 var xConfidence = Math.min(Math.abs(xOffset) / element.offsetWidth, 1);
		var yConfidence = Math.min(Math.abs(yOffset) / element.offsetHeight, 1);

		return Math.min(1, Math.max(xConfidence*2, yConfidence*2) );
	}
	
	function onThrowOutEnd(e:SwingCardEvent):Void
	{

		var el:HtmlElement = e.target;
		var index:Int = Std.parseInt(el.getAttribute("index"));
		var tarIndexBefore:Int = index < this.beltAmount - 1 ? index + 1 : 0;
		
		
		var par = el.parentNode;
		par.removeChild(el);

		var child:HtmlElement =  cast par.firstChild;
		
		while ( Std.parseInt(child.getAttribute("index")) != tarIndexBefore) {
			child = cast child.nextSibling;
		}

		par.insertBefore(el, child);
		var card = _vData._stack.getCard(el);
		
	
		card.throwIn(0, 0);
	}
	
	@:action static var actions:GameActions;
	
	function onThrowOut(e:SwingCardEvent):js.Promise<CardResult> {
		var stack = _vData._stack;
	
	
		var result;
		if (e.throwDirection != SwingDirection.RIGHT) {
			result = actions._swipe(store, false);
		}
		else {
			result = actions._swipe(store, true);

		}
	
	//	/*

		result.then( function(cardResult) {

			switch(cardResult) {
				
				case CardResult.NOT_YET_AVAILABLE(_, _) | CardResult.NOTHING:
					var card = stack.getCard(e.target);
					card.throwIn(0, 0);

					//e.target.setAttribute("data-canceled", "1");
					//var p = e.target.parentNode;
					//p.removeChild(e.target);
					//p.appendChild(e.target);
				default:
					--this.topCardIndex;
					//e.target.setAttribute("data-canceled", "");
					if (this.topCardIndex < 0) this.topCardIndex = this.beltAmount - 1;
					// track top card index on belt
					
					
			}
		
		});
		//*/
		
		return result;
	}
	
	///*
	override public function Data():SwingStackData {
		return getBeltData(7);
	}
	//*/
	
	public static function getBeltData(capacity:Int):SwingStackData {
		 return {
			refCards: BaseCardView.getEmptyBelt(capacity),
			topCardIndex:capacity - 1,
			beltAmount:capacity
		};
	}



}
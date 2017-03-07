package gajus.swing;
import js.html.HtmlElement;

/**
 * ...
 * @author Glidias
 */
@:jsRequire("Swing")
extern class Swing
{
	public static function Stack(?config:Dynamic):SwingStack;
}

@:jsRequire("Swing", "Stack")
extern class SwingStack
{
	public function createCard(htmlElement:HtmlElement):SwingCard;
	public function getCard(htmlElement:HtmlElement):SwingCard;
	public function on(evtStr:String, handler:SwingCardEvent->Void):Void;
	
	
}

@:jsRequire("Swing", "Card")
extern class SwingCard
{
	public function throwIn(x:Float, y:Float):Void;
	public function throwOut(x:Float, y:Float):Void;
	public static var DIRECTION_UP:String;
	public static var DIRECTION_DOWN:String;
	public static var DIRECTION_LEFT:String;
	public static var DIRECTION_RIGHT:String;
}


typedef SwingCardEvent = {
	var target:HtmlElement;
	var direction:String;
	var throwOutConfidence:Float;
}
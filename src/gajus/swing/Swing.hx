package gajus.swing;
import js.html.HtmlElement;

/**
 * ...
 * @author Glidias
 */
@:jsRequire("swing")
extern class Swing
{
	public static function Stack(?config:Dynamic):SwingStack;
}

@:jsRequire("swing", "Stack")
extern class SwingStack
{
	public function createCard(htmlElement:HtmlElement):SwingCard;
	public function getCard(htmlElement:HtmlElement):SwingCard;
	public function on(evtStr:String, handler:SwingCardEvent->Void):Void;
	
	
}

@:jsRequire("swing", "Card")
extern class SwingCard
{
	public function throwIn(x:Float, y:Float):Void;
	public function throwOut(x:Float, y:Float):Void;

}

@:jsRequire("swing", "Direction")
extern class SwingDirection
{
	public static var UP:Dynamic;
	public static var DOWN:Dynamic;
	public static var LEFT:Dynamic;
	public static var RIGHT:Dynamic;
}

typedef SwingCardEvent = {
	var target:HtmlElement;
	var throwDirection:Dynamic;
	var throwOutConfidence:Float;
}
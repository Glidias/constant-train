package cstrain.vuex.swing;
import js.html.HtmlElement;

/**
 * ...
 * @author Glidias
 */
@:jsRequire("Swing")
extern class Swing
{
	public static function Stack():SwingStack;
}

@:jsRequire("Swing", "Stack")
extern class SwingStack
{
	public function createCard(htmlElement:HtmlElement):Dynamic;
}
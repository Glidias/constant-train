package;
import cstrain.core.Polynomial;
import cstrain.h2d.AbstractBGScene;
import cstrain.h2d.TrainBGScene;
import cstrain.rules.SceneModel;
import cstrain.rules.TestGame;
import cstrain.rules.systems.MonsterChasePlayerSystem;
import cstrain.vuex.components.BasicTypes.TouchVUtil;
import cstrain.vuex.components.GameView;
import cstrain.vuex.components.MainVue;
import cstrain.vuex.game.GameMenuActions;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.VxBoot;
import haxevx.vuex.native.Vue;
import js.Browser;

/**
 * ...
 * @author Glidias
 */
class Main
{
	var boot:VxBoot;

	public static function main() 
	{
		// Main App
		new Main();

	}
	
	function new() {
		boot = new VxBoot();
		TouchVUtil.IS_TOUCH_BASED =  Reflect.hasField( Browser.window, "ontouchstart");
		
		Vue.use(VueTouch, {name:TouchVUtil.TAG});
		
		var sm = new SceneModel();
		

		var gs = new GameStore() ;

		var store = boot.startStore( gs) ;

		// Background scene visual
		//hxd.Res.initEmbed();
		
		// for now , this would suffice, a bit hackish..
		GameMenuActions.BGTRAIN =  sm;

		// this is the main looper driver (for now...may refactor);
		AbstractBGScene.signalInited.addOnce( onInited);
		new TrainBGScene( sm);
	}
	
	private function onInited():Void {
		boot.startVueWithRootComponent( "#app", new MainVue());
		VxBoot.notifyStarted();
	}
	
}

@:jsRequire("vue-touch")
extern class VueTouch {
	
}
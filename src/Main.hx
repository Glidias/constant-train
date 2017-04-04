package;
import cstrain.core.Polynomial;
import cstrain.h2d.TrainBGScene;
import cstrain.rules.SceneModel;
import cstrain.rules.TestGame;
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

	public static function main() 
	{
		// Main App
		var boot:VxBoot = new VxBoot();
		TouchVUtil.IS_TOUCH_BASED =  Reflect.hasField( Browser.window, "ontouchstart");
		
		Vue.use(VueTouch, {name:TouchVUtil.TAG});
		
		var sm = new SceneModel();
		var rules = new TestGame();
		
		rules.restart();
		var gs = new GameStore(rules, sm) ;
		

		var store = boot.startStore( gs) ;
		
		
		boot.startVueWithRootComponent( "#app", new MainVue());
		VxBoot.notifyStarted();
		
		// Background scene visual
		//hxd.Res.initEmbed();
		
		// for now , this would suffice, a bit hackish..
		GameMenuActions.BGTRAIN =  sm;

		// this is the main looper driver
		new TrainBGScene( sm);
		
	
		

	}
	
}

@:jsRequire("vue-touch")
extern class VueTouch {
	
}